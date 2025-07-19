import { lazy } from 'react';
import { Navigate } from 'react-router-dom';
import PropTypes from 'prop-types';
import Loadable from '../layouts/loader/Loadable';
/****Layouts*****/

// autenticação do login para rotas privadas
const Private = ({ children }) => {
  const token = JSON.parse(localStorage.getItem('isLogged'));
  const permission = JSON.parse(localStorage.getItem('permission'));
  if (!token || !permission) {
    return <Navigate to="/" />;
  }
  return children;
};

const PrivateLogin = ({ children }) => {
  const token = JSON.parse(localStorage.getItem('isLogged'));
  const permission = JSON.parse(localStorage.getItem('permission'));
  if (token && permission) {
    return <Navigate to="/dashboard" />;
  }
  return children;
};

const FullLayout = Loadable(lazy(() => import('../layouts/FullLayout')));
const BlankLayout = Loadable(lazy(() => import('../layouts/BlankLayout')));
/***** Pages ****/

/* ************************************************************************************************************** */

//Dashboards
const Dashboard = Loadable(lazy(() => import('../pages/dashboard/Dashboard')));

//Cadastros
const Empresas = Loadable(lazy(() => import('../pages/cadastro/Empresas')));
const Pessoas = Loadable(lazy(() => import('../pages/cadastro/Pessoas')));
const Produtos = Loadable(lazy(() => import('../pages/cadastro/Produtos')));
const Veiculos = Loadable(lazy(() => import('../pages/cadastro/Veiculos')));
const Planoconta = Loadable(lazy(() => import('../pages/cadastro/Planoconta')));
const Despesas = Loadable(lazy(() => import('../pages/cadastro/Despesas')));
const Multas = Loadable(lazy(() => import('../pages/cadastro/Multas')));
const Fornecedor = Loadable(lazy(() => import('../pages/cadastro/Fornecedor')));
const Monitoramento = Loadable(lazy(() => import('../pages/cadastro/Monitoramento')));
const Rh = Loadable(lazy(() => import('../pages/cadastro/Rh')));

//Suprimentos
const Estoques = Loadable(lazy(() => import('../pages/suprimento/Estoques')));
const Compras = Loadable(lazy(() => import('../pages/suprimento/Compras')));
const Solicitacao = Loadable(lazy(() => import('../pages/suprimento/Solicitacao')));
const SolicitacaoAvulso = Loadable(lazy(() => import('../pages/suprimento/Solicitacao-Avulso')));
const Requisicao = Loadable(lazy(() => import('../pages/suprimento/Requisicao')));

//clientes
const Clienteericsson = Loadable(lazy(() => import('../pages/projeto/Clienteericsson')));
const Clientehuawei = Loadable(lazy(() => import('../pages/projeto/Clientehuawei')));
const Clientezte = Loadable(lazy(() => import('../pages/projeto/Clientezte')));
const Clientecosmx = Loadable(lazy(() => import('../pages/projeto/Clientecosmx')));
const Clientetelefonica = Loadable(lazy(() => import('../pages/projeto/Clientetelefonica')));

//Projetos
const Fechamentoericsson = Loadable(lazy(() => import('../pages/fechamento/Fechamentoericsson')));
const Fechamentocosmx = Loadable(lazy(() => import('../pages/fechamento/Fechamentocosmx')));

//comercial
const Comercial = Loadable(lazy(() => import('../pages/comercial/Comercial')));

//Reltorio
const Relatoriomenu = Loadable(lazy(() => import('../pages/relatorio/Relatoriomenu')));

//Demonstrativo
const Despesageral = Loadable(lazy(() => import('../pages/despesa/Despesageral')));

//Configurações
const Controleacesso = Loadable(lazy(() => import('../pages/configuracao/Controleacesso')));
const ConfiguracaoDeAvisoEmail = Loadable(
  lazy(() => import('../pages/configuracao/ConfiguracaoDeAvisosEmail')),
);

/* ************************************************************************************************************** */
const LoginFormik = Loadable(lazy(() => import('../views/auth/LoginFormik')));
const RecoverPassword = Loadable(lazy(() => import('../views/auth/RecoverPassword')));

/*****Routes******/

const ThemeRoutes = [
  {
    path: '/',
    element: <BlankLayout />,
    children: [
      //login
      {
        path: '/',
        name: 'login',
        element: (
          <PrivateLogin>
            <LoginFormik />
          </PrivateLogin>
        ),
      },
      {
        path: '/recuperar-senha',
        name: 'recoverPassword',
        element: (
          <PrivateLogin>
            <RecoverPassword />
          </PrivateLogin>
        ),
      },
    ],
  },
  {
    path: '/',
    element: <FullLayout />,
    children: [
      //Dashboard
      {
        path: '/dashboard',
        name: 'Dashboard',
        exact: true,
        element: (
          <Private>
            <Dashboard />
          </Private>
        ),
      },

      //Cadastros
      {
        path: '/cadastro/empresas',
        name: 'Empresas',
        exact: true,
        element: (
          <Private>
            <Empresas />
          </Private>
        ),
      },
      {
        path: '/cadastro/pessoas',
        name: 'Pessoas',
        exact: true,
        element: (
          <Private>
            <Pessoas />
          </Private>
        ),
      },
      {
        path: '/cadastro/rh',
        name: 'RH',
        exact: true,
        element: (
          <Private>
            <Rh />
          </Private>
        ),
      },
      {
        path: '/cadastro/fornecedor',
        name: 'Fornecedor',
        exact: true,
        element: (
          <Private>
            <Fornecedor />
          </Private>
        ),
      },
      {
        path: '/cadastro/produtos',
        name: 'Produtos',
        exact: true,
        element: (
          <Private>
            <Produtos />
          </Private>
        ),
      },
      {
        path: '/cadastro/veiculos',
        name: 'Veiculos',
        exact: true,
        element: (
          <Private>
            <Veiculos />
          </Private>
        ),
      },
      {
        path: '/cadastro/planoconta',
        name: 'Planoconta',
        exact: true,
        element: (
          <Private>
            <Planoconta />
          </Private>
        ),
      },
      {
        path: '/cadastro/despesas',
        name: 'Despesas',
        exact: true,
        element: (
          <Private>
            <Despesas />
          </Private>
        ),
      },
      {
        path: '/cadastro/multas',
        name: 'Multas',
        exact: true,
        element: (
          <Private>
            <Multas />
          </Private>
        ),
      },
      {
        path: '/cadastro/monitoramento',
        name: 'Monitoramento',
        exact: true,
        element: (
          <Private>
            <Monitoramento />
          </Private>
        ),
      },

      //Suprimento
      {
        path: '/suprimentos/estoque',
        name: 'Controle',
        exact: true,
        element: (
          <Private>
            <Estoques />
          </Private>
        ),
      },
      {
        path: '/suprimentos/compras',
        name: 'Compras',
        exact: true,
        element: (
          <Private>
            {' '}
            <Compras />{' '}
          </Private>
        ),
      },
      {
        path: '/suprimentos/requisicao',
        name: 'Requisição',
        exact: true,
        element: (
          <Private>
            <Requisicao />
          </Private>
        ),
      },
      {
        path: '/suprimentos/solicitacao',
        name: 'Solicitação',
        exact: true,
        element: (
          <Private>
            {' '}
            <Solicitacao />{' '}
          </Private>
        ),
      },
      {
        path: '/suprimentos/solicitacao-avulso',
        name: 'Solicitação Avulso',
        exact: true,
        element: (
          <Private>
            {' '}
            <SolicitacaoAvulso />{' '}
          </Private>
        ),
      },

      //Projetos
      // { path: '/projeto', name: 'Projeto', exact: true, element: <Projeto /> },
      {
        path: '/cliente/ericsson',
        name: 'Ericsson',
        exact: true,
        element: (
          <Private>
            <Clienteericsson />
          </Private>
        ),
      },
      {
        path: '/cliente/huawei',
        name: 'Huawei',
        exact: true,
        element: (
          <Private>
            <Clientehuawei />
          </Private>
        ),
      },
      {
        path: '/cliente/zte',
        name: 'zte',
        exact: true,
        element: (
          <Private>
            <Clientezte />
          </Private>
        ),
      },
      {
        path: '/cliente/cosmx',
        name: 'cosmx',
        exact: true,
        element: (
          <Private>
            <Clientecosmx />
          </Private>
        ),
      },

      {
        path: '/cliente/telefonica',
        name: 'telefonica',
        exact: true,
        element: (
          <Private>
            <Clientetelefonica />
          </Private>
        ),
      },

      //fechaemntos
      // { path: '/projeto', name: 'Projeto', exact: true, element: <Projeto /> },
      {
        path: '/fechamento/ericsson',
        name: 'Fechamentoericsson',
        exact: true,
        element: (
          <Private>
            <Fechamentoericsson />
          </Private>
        ),
      },
      {
        path: '/fechamento/cosmx',
        name: 'Fechamentocosmx',
        exact: true,
        element: (
          <Private>
            <Fechamentocosmx />
          </Private>
        ),
      },
      //comercial
      {
        path: 'comercial',
        name: 'comercial',
        exact: true,
        element: (
          <Private>
            <Comercial />
          </Private>
        ),
      },

      //Relatorio
      {
        path: '/relatorio',
        name: 'Relatorio',
        exact: true,
        element: (
          <Private>
            <Relatoriomenu />
          </Private>
        ),
      },

      //Demonstrativo
      {
        path: '/despesageral',
        name: 'Despesageral',
        exact: true,
        element: (
          <Private>
            <Despesageral />
          </Private>
        ),
      },

      //Configuração
      {
        path: '/configuracao/controleacesso',
        name: 'Controleacesso',
        exact: true,
        element: (
          <Private>
            <Controleacesso />
          </Private>
        ),
      },
      {
        path: '/configuracao/avisos',
        name: 'Avisos',
        exact: true,
        element: (
          <Private>
            <ConfiguracaoDeAvisoEmail />
          </Private>
        ),
      },
    ],
  },
];

Private.propTypes = {
  children: PropTypes.node.isRequired,
};

PrivateLogin.propTypes = {
  children: PropTypes.node.isRequired,
};

export default ThemeRoutes;
