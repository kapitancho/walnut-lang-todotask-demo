class TodoTask extends HTMLElement {
	constructor() {
		super();
		this.attachShadow({ mode: 'open' });
	}
	connectedCallback() {
		const template = document.createElement('template');
		template.innerHTML = `
			<style>
                      :host div {
                          display: grid;
                          grid-template-rows: 30px 150px 30px 30px 30px 30px;
                      }
                      :host div[done="1"] {
                            background: greenyellow;
                      }
                      :host div[done="0"] {
                            background: lightpink;
                      }
			</style>
			<div>
				<h3><slot name="title" /></h3>
				<p><slot name="description" /></p>
				<span class="created-at">Since: <slot name="created-at" /></span>
				<span class="due-date">Due:<slot name="due-date" /></span>
				<label><input type="checkbox" name="is-done" />done</label>
				<button type="button">delete</button>
			</div>
		`;
		this.shadowRoot.appendChild(template.content.cloneNode(true));
		const div = this.shadowRoot.querySelector('div');
		div.setAttribute('done', this.hasAttribute('done') && this.getAttribute('done') === 'true' ? '1' : '0');
		const cb = this.shadowRoot.querySelector('[name="is-done"]');
		cb.checked = this.hasAttribute('done') && this.getAttribute('done') === 'true';
		cb.addEventListener('change', async () => {
			if (cb.checked) {
				await clientProxy.markTaskAsDone(this.getAttribute('id'));
			} else {
				await clientProxy.unmarkTaskAsDone(this.getAttribute('id'));
			}
			div.setAttribute('done', cb.checked ? '1' : '0');
		});
		this.shadowRoot.querySelector('button').addEventListener('click', async () => {
			await clientProxy.removeTask(this.getAttribute('id'));
			this.parentNode.remove();
		});
	}
}
customElements.define('todo-task', TodoTask);
