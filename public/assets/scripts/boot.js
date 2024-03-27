import ServerProxy from './server-proxy.js' ;
import Client from './client.js';

// noinspection JSFileReferences
import { apiEndpoint, webEndpoint } from './env.js';

export default new Client(
	new ServerProxy(
		apiEndpoint,
		webEndpoint,
		errorMessage => document.querySelector('#current-error').innerHTML = errorMessage
	)
);
