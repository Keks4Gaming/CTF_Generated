<script>
	let { error, status } = $props();

	const title = status === 404 ? "Page not found" : "Something went wrong";
	const message =
		status === 404
			? "The page you are looking for has moved or never existed."
			: error?.message || "Unexpected error. Try again in a moment.";
</script>

<section class="error">
	<div class="error-card">
		<p class="eyebrow">{status}</p>
		<h1>{title}</h1>
		<p class="detail">{message}</p>
		<div class="actions">
			<a class="button solid" href="/">Back to home</a>
			<a class="button ghost" href="/login">Login</a>
		</div>
	</div>
</section>

<style>
	.error {
		min-height: 50vh;
		display: grid;
		place-items: center;
	}

	.error-card {
		background: rgba(255, 255, 255, 0.85);
		border-radius: 24px;
		padding: 32px;
		max-width: 520px;
		box-shadow: var(--shadow);
		text-align: center;
		border: 1px solid rgba(27, 27, 29, 0.08);
	}

	.eyebrow {
		letter-spacing: 0.2em;
		text-transform: uppercase;
		font-size: 12px;
		font-weight: 600;
		color: var(--accent-dark);
		margin: 0 0 8px;
	}

	h1 {
		margin: 0 0 12px;
		font-family: "Fraunces", "Times New Roman", serif;
		font-size: clamp(28px, 4vw, 40px);
	}

	.detail {
		margin: 0 0 20px;
		color: rgba(27, 27, 29, 0.7);
		line-height: 1.6;
	}

	.actions {
		display: flex;
		justify-content: center;
		gap: 12px;
		flex-wrap: wrap;
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

	.button.solid:hover {
		transform: translateY(-1px);
		background: var(--accent-dark);
	}

	.button.ghost {
		border-color: rgba(27, 27, 29, 0.2);
		background: rgba(255, 255, 255, 0.85);
	}
</style>
