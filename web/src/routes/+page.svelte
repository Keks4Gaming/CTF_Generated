<section class="hero">
	<div class="hero-copy">
		<p class="eyebrow">PWN Journal</p>
		<h1>Write with signal, publish with calm.</h1>
		<p class="lead">
			A focused space for crisp notes, fast drafts, and clear thinking. Keep the noise out and
			ship the words that matter.
		</p>
		<div class="cta-row">
			<a class="button solid" href="/login">Sign in</a>
			<a class="button ghost" href="#features">See the workflow</a>
		</div>
		<div class="meta">
			<span>Zero clutter</span>
			<span>Private by default</span>
			<span>Built for momentum</span>
		</div>
	</div>
	<div class="hero-panel">
		<div class="panel-card">
			<p class="panel-title">Draft: Morning loops</p>
			<p class="panel-body">
				Three paragraphs. One idea. Trim the rest. Keep the pulse. Publish when it is ready.
			</p>
			<div class="panel-tags">
				<span>Focus</span>
				<span>Draft</span>
				<span>5 min</span>
			</div>
		</div>
		<div class="panel-stats">
			<div>
				<p class="stat">18</p>
				<p class="stat-label">drafts this week</p>
			</div>
			<div>
				<p class="stat">2</p>
				<p class="stat-label">published today</p>
			</div>
			<div>
				<p class="stat">94%</p>
				<p class="stat-label">signal ratio</p>
			</div>
		</div>
	</div>
</section>

<section id="features" class="features">
	<div class="feature">
		<h2>Quiet workspace</h2>
		<p>Keep drafts private until you are ready. Nothing leaks, nothing nags.</p>
	</div>
	<div class="feature">
		<h2>Fast capture</h2>
		<p>Drop a thought, tag it, move on. The editor stays out of your way.</p>
	</div>
	<div class="feature">
		<h2>Intentional publish</h2>
		<p>Ship only the notes you mean to share. Everything else stays yours.</p>
	</div>
</section>

<section class="cta">
	<h2>Start the next paragraph.</h2>
	<p>Log in and pick up where your latest idea left off.</p>
	<a class="button solid" href="/login">Go to login</a>
</section>

<style>
	.hero {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
		gap: 32px;
		align-items: center;
	}

	.hero-copy h1 {
		margin: 0 0 14px;
		font-family: "Fraunces", "Times New Roman", serif;
		font-size: clamp(32px, 4vw, 54px);
	}

	.eyebrow {
		letter-spacing: 0.24em;
		text-transform: uppercase;
		font-size: 12px;
		font-weight: 600;
		color: var(--accent-dark);
	}

	.lead {
		margin: 0 0 24px;
		line-height: 1.7;
		color: rgba(27, 27, 29, 0.75);
	}

	.cta-row {
		display: flex;
		flex-wrap: wrap;
		gap: 12px;
		margin-bottom: 20px;
	}

	.meta {
		display: flex;
		gap: 16px;
		flex-wrap: wrap;
		font-size: 13px;
		color: rgba(27, 27, 29, 0.6);
	}

	.hero-panel {
		background: rgba(255, 255, 255, 0.7);
		border: 1px solid rgba(27, 27, 29, 0.08);
		border-radius: 24px;
		padding: 24px;
		box-shadow: var(--shadow);
		display: grid;
		gap: 20px;
	}

	.panel-card {
		background: white;
		border-radius: 20px;
		padding: 18px;
		box-shadow: 0 12px 24px rgba(19, 28, 24, 0.12);
	}

	.panel-title {
		margin: 0 0 10px;
		font-weight: 600;
	}

	.panel-body {
		margin: 0 0 14px;
		color: rgba(27, 27, 29, 0.7);
		line-height: 1.6;
	}

	.panel-tags {
		display: flex;
		gap: 8px;
		flex-wrap: wrap;
		font-size: 12px;
	}

	.panel-tags span {
		background: rgba(11, 107, 87, 0.12);
		color: var(--accent-dark);
		padding: 4px 8px;
		border-radius: 999px;
		font-weight: 600;
	}

	.panel-stats {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 12px;
		text-align: center;
	}

	.stat {
		margin: 0;
		font-size: 20px;
		font-weight: 700;
		color: var(--accent-dark);
	}

	.stat-label {
		margin: 2px 0 0;
		font-size: 12px;
		color: rgba(27, 27, 29, 0.6);
	}

	.features {
		margin: 64px 0 48px;
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
		gap: 20px;
	}

	.feature {
		background: rgba(255, 255, 255, 0.75);
		border-radius: 20px;
		padding: 20px;
		border: 1px solid rgba(27, 27, 29, 0.08);
	}

	.feature h2 {
		margin: 0 0 8px;
		font-size: 18px;
		font-weight: 600;
	}

	.feature p {
		margin: 0;
		color: rgba(27, 27, 29, 0.7);
		line-height: 1.6;
	}

	.cta {
		background: linear-gradient(120deg, rgba(11, 107, 87, 0.12), rgba(240, 176, 77, 0.16));
		border-radius: 24px;
		padding: 28px;
		text-align: center;
	}

	.cta h2 {
		margin: 0 0 8px;
		font-family: "Fraunces", "Times New Roman", serif;
		font-size: 26px;
	}

	.cta p {
		margin: 0 0 16px;
		color: rgba(27, 27, 29, 0.7);
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
		background: rgba(255, 255, 255, 0.8);
	}

	@media (max-width: 720px) {
		.panel-stats {
			grid-template-columns: 1fr;
			text-align: left;
		}

		.cta-row {
			flex-direction: column;
			align-items: flex-start;
		}
	}
</style>
