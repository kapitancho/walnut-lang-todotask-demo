class Client {
	/**
	 * @param {ServerProxy} serverProxy
	 */
	constructor(serverProxy) {
		this.serverProxy = serverProxy;
	}

	async taskList() {
		return (await this.serverProxy.apiCall('/tasks', 'GET',
			null, [200]))?.json;
	}

	async task(taskId) {
		return (await this.serverProxy.apiCall(`/tasks/${taskId}`, 'GET',
			null, [200]))?.json;
	}

	async newTask(title, dueDate, description) {
		const parts = dueDate.split('-');
		return (await this.serverProxy.apiCall('/tasks', 'POST',
			JSON.stringify({title, dueDate: {
				year: parseInt(parts[0], 10),
				month: parseInt(parts[1], 10),
				day: parseInt(parts[2], 10)
			}, description}), [201]))?.location;
	}

	async markTaskAsDone(taskId) {
		return await this.serverProxy.apiCall(`/tasks/${taskId}/done`, 'POST', null, [204]);
	}

	async unmarkTaskAsDone(taskId) {
		return await this.serverProxy.apiCall(`/tasks/${taskId}/done`, 'DELETE', null, [204]);
	}

	async removeTask(taskId) {
		return (await this.serverProxy.apiCall(`/tasks/${taskId}`, 'DELETE', null,  [204]));
	}

}

export default Client;