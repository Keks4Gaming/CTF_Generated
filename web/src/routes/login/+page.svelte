<script>
	import { goto } from "$app/navigation";

	let email = $state("");
	let password = $state("");
	let error = $state("");
	let success = $state("");
	let loading = $state(false);

	const getErrorDetail = async (/** @type {Response} */ response) => {
		const contentType = response.headers.get("content-type") ?? "";
		if (contentType.includes("application/json")) {
			const data = await response.json();
			return data?.message ?? data?.error ?? "";
		}

		return await response.text();
	};

	const handleSubmit = async () => {
		error = "";
		success = "";
		loading = true;

		try {
			const apiBase = import.meta.env.VITE_API_BASE || `http://${window.location.hostname}:7401`;
			const response = await fetch(`${apiBase}/api/login`, {
				method: "POST",
				headers: {
					"content-type": "application/json"
				},
				credentials: "include",
				body: JSON.stringify({ email, password })
			});

			if (!response.ok) {
				const detail = await getErrorDetail(response);
				throw new Error(detail || `Login failed (${response.status})`);
			}

			success = "Logged in. Redirecting...";
			await new Promise((resolve) => setTimeout(resolve, 400));
			await goto("/");
		} catch (err) {
			error = err instanceof Error ? err.message : "Login failed.";
		} finally {
			loading = false;
		}
	};
</script>

<section class="login">
	<div class="login-copy">
		<p class="eyebrow">Welcome back</p>
		<h1>Log in to your writing space.</h1>
		<p>
			The backend at <span class="code">/api/login</span> returns a JWT token as a cookie. This
			form sends credentials and lets the cookie settle for the next request.
		</p>
		<ul class="notes">
			<li>Keep drafts private until you publish.</li>
			<li>Jump back into your latest ideas.</li>
			<li>One login, zero distractions.</li>
		</ul>
	</div>

	<form class="login-card" on:submit|preventDefault={handleSubmit}>
		<h2>Login</h2>
		<label>
			Email
			<input
				type="email"
				name="email"
				autocomplete="email"
				placeholder="you@example.com"
				bind:value={email}
				required
			/>
		</label>
		<label>
			Password
			<input
				type="password"
				name="password"
				autocomplete="current-password"
				placeholder="Your password"
				bind:value={password}
				required
			/>
		</label>
		<button class="button solid" type="submit" disabled={loading}>
			{loading ? "Signing in..." : "Sign in"}
		</button>
		{#if error}
			<p class="status error" role="alert">{error}</p>
		{/if}
		{#if success}
			<p class="status success" aria-live="polite">{success}</p>
		{/if}
		<p class="helper">By logging in you agree to keep your notes intentional.</p>
	</form>
</section>

<style>
	.login {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
		gap: 32px;
		align-items: center;
	}

	.login-copy h1 {
		margin: 0 0 12px;
		font-family: "Fraunces", "Times New Roman", serif;
		font-size: clamp(28px, 3vw, 40px);
	}

	.login-copy p {
		margin: 0 0 16px;
		color: rgba(27, 27, 29, 0.7);
		line-height: 1.6;
	}

	.code {
		background: rgba(11, 107, 87, 0.12);
		padding: 2px 6px;
		border-radius: 6px;
		font-weight: 600;
	}

	.notes {
		margin: 0;
		padding-left: 18px;
		color: rgba(27, 27, 29, 0.75);
		line-height: 1.7;
	}

	.login-card {
		background: white;
		border-radius: var(--radius);
		padding: 28px;
		box-shadow: var(--shadow);
		display: flex;
		flex-direction: column;
		gap: 16px;
	}

	.button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 8px;
		padding: 12px 20px;
		border-radius: 999px;
		font: inherit;
		font-weight: 600;
		border: 1px solid transparent;
		cursor: pointer;
		transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
	}

	.button.solid {
		background: var(--accent);
		color: white;
		box-shadow: 0 12px 26px rgba(11, 107, 87, 0.2);
	}

	.button.solid:hover:not(:disabled) {
		transform: translateY(-1px);
		background: var(--accent-dark);
	}

	.button:disabled {
		cursor: not-allowed;
		opacity: 0.7;
		box-shadow: none;
	}

	.login-card h2 {
		margin: 0;
		font-family: "Fraunces", "Times New Roman", serif;
		font-size: 24px;
	}

	label {
		display: flex;
		flex-direction: column;
		gap: 8px;
		font-weight: 600;
		font-size: 14px;
	}

	input {
		padding: 12px 14px;
		border-radius: 12px;
		border: 1px solid rgba(27, 27, 29, 0.2);
		font: inherit;
		background: rgba(246, 241, 234, 0.6);
	}

	input:focus {
		outline: 2px solid rgba(11, 107, 87, 0.25);
		border-color: rgba(11, 107, 87, 0.5);
	}

	.status {
		margin: 0;
		padding: 10px 12px;
		border-radius: 12px;
		font-size: 14px;
	}

	.status.error {
		background: rgba(216, 106, 90, 0.15);
		color: #8c2b22;
	}

	.status.success {
		background: rgba(11, 107, 87, 0.12);
		color: var(--accent-dark);
	}

	.helper {
		margin: 0;
		font-size: 12px;
		color: rgba(27, 27, 29, 0.5);
	}

	@media (max-width: 720px) {
		.login-card {
			order: -1;
		}
	}
</style>
