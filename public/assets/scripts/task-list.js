import clientProxy from './boot.js';

export default async function (container) {
	let fn = async () => {
		let tasks = await clientProxy.taskList();
		container.innerHTML = '';
		tasks.forEach(task => {
			let li = document.createElement('li');
			li.innerHTML = `
				<todo-task done="${task.isDone}" id="${task.id}">
					<span slot="title">${task.title}</span>
					<span slot="description">${task.description}</span>
					<span slot="created-at">${task.createdAt.date.year}-${String(task.createdAt.date.month).padStart(2, '0')}-${String(task.createdAt.date.day).padStart(2, '0')}</span>
					<span slot="due-date">${task.dueDate.year}-${String(task.dueDate.month).padStart(2, '0')}-${String(task.dueDate.day).padStart(2, '0')}</span>
				</todo-task>
			`;
			container.appendChild(li);
		});
	};

	let form = document.querySelector('#add-task-form');
	form.addEventListener('submit', async (e) => {
		e.preventDefault();
		await clientProxy.newTask(
			form.querySelector('[name="title"]').value,
			form.querySelector('[name="due-date"]').value,
			form.querySelector('[name="description"]').value
		);
		await fn();
	});

	await fn();
}
