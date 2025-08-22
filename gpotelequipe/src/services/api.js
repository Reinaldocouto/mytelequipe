import axios from 'axios';

const api = axios.create({ baseURL: 'http://localhost:8145' }); //teste local
//const api = axios.create({ baseURL: 'https://appsiti.com.br:8145' }); //teste
//const api = axios.create({ baseURL: 'https://appsiti.com.br:8140' }); // produção
export default api;
