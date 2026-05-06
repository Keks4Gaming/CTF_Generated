const express = require('express');
const cors = require('cors');
const mariadb = require('mariadb');
const jwt = require('jsonwebtoken');

const app = express();
const port = 7401;
const HOST = '0.0.0.0';

const corsOriginEnv = process.env.CORS_ORIGIN || '';
const corsOrigins = (corsOriginEnv || 'http://localhost:3000,http://127.0.0.1:3000')
	.split(',')
	.map((origin) => origin.trim())
	.filter(Boolean);
const jwtSecret = process.env.JWT_SECRET || 'dev-secret-change-me';
const tokenName = 'auth_token';
const tokenMaxAgeMs = 60 * 60 * 1000;

const pool = mariadb.createPool({
	host: 'localhost',
	user: 'root',
	password: '1234',
	database: 'pwnbox'
});

const isAllowedOrigin = (origin) => {
	if (!origin) {
		return true;
	}

	if (corsOrigins.includes('*')) {
		return true;
	}

	if (corsOrigins.includes(origin)) {
		return true;
	}

	if (!corsOriginEnv) {
		try {
			const url = new URL(origin);
			return url.port === '3000';
		} catch (err) {
			return false;
		}
	}

	return false;
};

const corsOptions = {
	origin: (origin, callback) => {
		if (isAllowedOrigin(origin)) {
			return callback(null, true);
		}

		return callback(new Error('Origin not allowed by CORS'));
	},
	credentials: true
};

app.use(cors(corsOptions));
app.options(/.*/, cors(corsOptions));
app.use(express.json());

const getCookie = (cookieHeader, name) => {
	if (!cookieHeader) {
		return '';
	}

	const cookies = cookieHeader.split(';').map((cookie) => cookie.trim());
	for (const cookie of cookies) {
		if (cookie.startsWith(`${name}=`)) {
			return decodeURIComponent(cookie.slice(name.length + 1));
		}
	}

	return '';
};

const getAuthToken = (req) => {
	const authHeader = req.headers.authorization;
	if (authHeader && authHeader.startsWith('Bearer ')) {
		return authHeader.slice(7);
	}

	return getCookie(req.headers.cookie, tokenName);
};

const requireAuth = (req, res, next) => {
	const token = getAuthToken(req);
	if (!token) {
		return res.status(401).json({ message: 'Missing auth token.' });
	}

	try {
		req.user = jwt.verify(token, jwtSecret);
		return next();
	} catch (err) {
		return res.status(401).json({ message: 'Invalid or expired token.' });
	}
};

const requireAdmin = (req, res, next) => {
	if (!req.user?.isAdmin) {
		return res.status(403).json({ message: 'Admin access required.' });
	}

	return next();
};

app.route("/api")
.get((req, res) => {
	res.json({ message: "Hello World!" });
});

const handleLogin = async (req, res) => {
	const source = Object.keys(req.body ?? {}).length ? req.body : req.query;
	const login = source.username ?? source.email;
	const password = source.password;
	console.log("password: ", password, "\nuser: ", login);
	

	if (!login || !password) {
		return res.status(400).json({ message: 'Username/email and password are required.' });
	}

	let conn;
	try {
		conn = await pool.getConnection();
		const rows = await conn.query(
			"SELECT * FROM users WHERE email = '"+login+"' AND password = '"+password+"'"
				);
		console.log(rows);
		if (rows === 0) {
			return res.status(401).json({ message: 'Invalid username or password!' });
		}

		const user = rows[0];
		const isAdmin = user.role === 'admin';
		const token = jwt.sign(
			{ sub: user.id, username: user.username ?? login, isAdmin },
			jwtSecret,
			{ expiresIn: '1h' }
		);

		res.cookie(tokenName, token, {
			httpOnly: true,
			sameSite: 'lax',
			secure: process.env.NODE_ENV === 'production',
			maxAge: tokenMaxAgeMs
		});

		return res.json({ message: 'Login successful!', isAdmin });
	} catch (err) {
		console.log(err);
		return res.status(500).json({ message: 'Internal server error!' });
	} finally {
		if (conn) {
			conn.end();
		}
	}
};

app.get('/api/login', handleLogin);
app.post('/api/login', handleLogin);

app.get('/api/me', requireAuth, (req, res) => {
	res.json({ user: { id: req.user.sub, username: req.user.username, isAdmin: req.user.isAdmin } });
});

app.get('/api/admin', requireAuth, requireAdmin, (req, res) => {
	res.json({ message: 'Admin access granted.' });
});

app.post("/api/admin/cmd", requireAuth, requireAdmin, async (req, res) => {
	const cmd = req.body.cmd;
	if (!cmd) {
		return res.status(400).json({ message: 'Missing cmd parameter.' });
	}
	console.log("Executing command: ", cmd);

	try {
		const { exec } = require('child_process');
		exec(cmd, (error, stdout, stderr) => {
			if (error) {
				return res.status(500).json({ message: 'Command execution failed.', error: error.message });
			}
			return res.json({ stdout, stderr });
		});
	} catch (err) {
		return res.status(500).json({ message: 'Internal server error.', error: err.message });
	}
});

app.listen(port, HOST, () => {
  console.log(`Server is running on port ${port}`);
});