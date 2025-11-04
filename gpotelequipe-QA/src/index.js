import { createRoot } from 'react-dom/client'; // Corrigido o caminho de importação
import { Provider } from 'react-redux';
import { BrowserRouter } from 'react-router-dom';
import reportWebVitals from './reportWebVitals';
import { store } from './store/Store';
import App from './App';
import './data';

createRoot(document.getElementById('root')).render(
  <Provider store={store}>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </Provider>,
);

// Se você quiser começar a medir o desempenho do seu aplicativo, passe uma função
// para registrar os resultados (por exemplo: reportWebVitals(console.log))
// ou envie para um ponto de análise. Saiba mais: https://bit.ly/CRA-vitals
reportWebVitals();
