<svelte:head>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" />
	<link
		href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700&family=Space+Grotesk:wght@400;500;600&display=swap"
		rel="stylesheet"
	/>
</svelte:head>

<a class="skip" href="#main">Skip to content</a>

<header class="site-header">
	<nav class="nav">
		<a class="brand" href="/">PWN Journal</a>
		<div class="nav-links">
			<a href="/">Blog</a>
			<a href="/login" class="button ghost">Login</a>
		</div>
	</nav>
</header>

<main id="main" class="site-main">
	<slot />
</main>

<footer class="site-footer">
    <p>Made by Nico Reichstein && Marco Haberstroh</p>
    <p>Minimal words, maximum signal. Built with SvelteKit.</p>
</footer>

<style>
	:global(:root) {
		--ink: #1b1b1d;
		--surface: #f6f1ea;
		--surface-strong: #efe4d6;
		--accent: #0b6b57;
		--accent-dark: #094a3d;
		--sun: #f0b04d;
		--rose: #d86a5a;
		--shadow: 0 18px 50px rgba(19, 28, 24, 0.16);
		--radius: 24px;
	}

	:global(*) {
		box-sizing: border-box;
	}

	:global(body) {
		margin: 0;
		font-family: "Space Grotesk", "Helvetica Neue", Helvetica, sans-serif;
		color: var(--ink);
		background: radial-gradient(circle at 15% 20%, rgba(240, 176, 77, 0.35), transparent 55%),
			linear-gradient(140deg, #fbf6ef, #f5efe8 45%, #f1e7db 100%);
		min-height: 100vh;
	}

	:global(body)::before {
		content: "";
		position: fixed;
		inset: -20vh 0 auto;
		height: 40vh;
		background: radial-gradient(circle at 70% 10%, rgba(11, 107, 87, 0.2), transparent 65%);
		pointer-events: none;
		z-index: 0;
	}

	:global(a) {
		color: inherit;
		text-decoration: none;
	}

	:global(img) {
		max-width: 100%;
		display: block;
	}

	.skip {
		position: absolute;
		left: -999px;
		top: 16px;
		background: var(--accent);
		color: white;
		padding: 10px 16px;
		border-radius: 999px;
		z-index: 10;
	}

	.skip:focus {
		left: 16px;
	}

	.site-header {
		position: sticky;
		top: 0;
		z-index: 5;
		backdrop-filter: blur(12px);
		background: rgba(246, 241, 234, 0.75);
		border-bottom: 1px solid rgba(27, 27, 29, 0.08);
	}

	.nav {
		max-width: 1100px;
		margin: 0 auto;
		padding: 20px 24px;
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 16px;
	}

	.brand {
		font-family: "Fraunces", "Times New Roman", serif;
		font-weight: 700;
		letter-spacing: 0.5px;
		font-size: 22px;
	}

	.nav-links {
		display: flex;
		align-items: center;
		gap: 16px;
		font-weight: 500;
	}

	.button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 8px;
		padding: 10px 18px;
		border-radius: 999px;
		font-weight: 600;
		border: 1px solid transparent;
		transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
	}

	.button.ghost {
		border-color: rgba(27, 27, 29, 0.2);
		background: rgba(255, 255, 255, 0.75);
	}

	.button.ghost:hover {
		transform: translateY(-1px);
		box-shadow: var(--shadow);
	}

	.site-main {
		position: relative;
		z-index: 1;
		max-width: 1100px;
		margin: 0 auto;
		padding: 56px 24px 96px;
	}

	.site-footer {
		border-top: 1px solid rgba(27, 27, 29, 0.1);
		padding: 28px 24px 40px;
		text-align: center;
		font-size: 14px;
		color: rgba(27, 27, 29, 0.7);
	}

	@media (max-width: 720px) {
		.nav {
			flex-direction: column;
			align-items: flex-start;
		}

		.site-main {
			padding-top: 40px;
		}
	}
</style>
