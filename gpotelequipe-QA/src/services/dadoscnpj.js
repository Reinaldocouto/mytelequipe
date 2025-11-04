import axios from 'axios';

const dadoscnpj = axios.create({ baseURL : 'https://www.receitaws.com.br/v1/cnpj' });

export default dadoscnpj;
