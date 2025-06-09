import { useState, useEffect } from 'react';
import * as Icon from 'react-feather';
import TimeToLeaveOutlinedIcon from '@mui/icons-material/TimeToLeaveOutlined';
import InventoryOutlinedIcon from '@mui/icons-material/InventoryOutlined';

const SidebarData = () => {
  const [menuItems, setMenuItems] = useState([]);

  useEffect(() => {
    const loadSidebarData = () => {
      try {
        const permissionstorage = JSON.parse(localStorage.getItem('permission')) || {};

        const items = [
          {
            title: 'Dashboards',
            href: '/dashboard',
            id: 1,
            suffixColor: 'bg-primary',
            icon: <Icon.Home />,
            collapisble: true,
          },
        ];

        // Cadastros
        if (
          permissionstorage?.pessoas === 1 ||
          permissionstorage?.produtos === 1 ||
          permissionstorage?.empresas === 1
        ) {
          const cadastrosChildren = [];

          if (permissionstorage?.empresas === 1) {
            cadastrosChildren.push({
              title: 'Empresas',
              href: '/cadastro/empresas',
              icon: <Icon.Disc />,
              id: 2.1,
              collapisble: false,
            });
          }

          if (permissionstorage?.pessoas === 1) {
            cadastrosChildren.push({
              title: 'Pessoas',
              href: '/cadastro/pessoas',
              icon: <Icon.Disc />,
              id: 2.2,
              collapisble: false,
            });
          }

          if (permissionstorage?.produtos === 1) {
            cadastrosChildren.push({
              title: 'Produtos',
              href: '/cadastro/produtos',
              icon: <Icon.Disc />,
              id: 2.4,
              collapisble: false,
            });
          }
          if (permissionstorage?.rh === 1) {
            cadastrosChildren.push({
              title: 'RH',
              href: '/cadastro/rh',
              icon: <Icon.Disc />,
              id: 2.4,
              collapisble: false,
            });
          }

          if (cadastrosChildren.length > 0) {
            items.push({
              title: 'Cadastros',
              href: '/cadastro',
              id: 2,
              suffixColor: 'bg-primary',
              icon: <InventoryOutlinedIcon />,
              collapisble: true,
              children: cadastrosChildren,
            });
          }
        }

        // Gestão de Frotas
        if (
          permissionstorage?.veiculos === 1 ||
          permissionstorage?.gestaomultas === 1 ||
          permissionstorage?.despesas === 1 ||
          permissionstorage?.monitoramento === 1
        ) {
          const frotasChildren = [];

          if (permissionstorage?.veiculos === 1) {
            frotasChildren.push({
              title: 'Veículos',
              href: '/cadastro/veiculos',
              icon: <Icon.Disc />,
              id: 3.1,
              collapsible: false,
            });
          }

          if (permissionstorage?.gestaomultas === 1) {
            frotasChildren.push({
              title: 'Gestão de Multas',
              href: '/cadastro/multas',
              icon: <Icon.Disc />,
              id: 3.2,
              collapsible: false,
            });
          }

          if (permissionstorage?.despesas === 1) {
            frotasChildren.push({
              title: 'Despesas',
              href: '/cadastro/despesas',
              icon: <Icon.Disc />,
              id: 3.3,
              collapsible: false,
            });
          }

          if (permissionstorage?.monitoramento === 1) {
            frotasChildren.push({
              title: 'Monitoramento',
              href: '/cadastro/monitoramento',
              icon: <Icon.Disc />,
              id: 3.4,
              collapsible: false,
            });
          }

          if (frotasChildren.length > 0) {
            items.push({
              title: 'Gestão de Frotas',
              href: '/suprimentos',
              id: 3,
              suffixColor: 'bg-primary',
              icon: <TimeToLeaveOutlinedIcon />,
              collapsible: true,
              children: frotasChildren,
            });
          }
        }

        // Suprimentos
        if (
          permissionstorage?.controleestoque === 1 ||
          permissionstorage?.compras === 1 ||
          permissionstorage?.solicitacao === 1 ||
          permissionstorage?.requisicao === 1 ||
          permissionstorage?.solicitacaoavulsa === 1
        ) {
          const suprimentosChildren = [];

          if (permissionstorage?.controleestoque === 1) {
            suprimentosChildren.push({
              title: 'Controle de Estoque',
              href: '/suprimentos/estoque',
              icon: <Icon.Disc />,
              id: 4.1,
              collapisble: false,
            });
          }

          if (permissionstorage?.compras === 1) {
            suprimentosChildren.push({
              title: 'Compras',
              href: '/suprimentos/compras',
              icon: <Icon.Disc />,
              id: 4.2,
              collapisble: false,
            });
          }

          if (permissionstorage?.solicitacao === 1) {
            suprimentosChildren.push({
              title: 'Solicitação de Material',
              href: '/suprimentos/solicitacao',
              icon: <Icon.Disc />,
              id: 4.3,
              collapisble: false,
            });
          }

          if (permissionstorage?.requisicao === 1) {
            suprimentosChildren.push({
              title: 'Requisição de Material',
              href: '/suprimentos/requisicao',
              icon: <Icon.Disc />,
              id: 4.4,
              collapisble: false,
            });
          }

          if (permissionstorage?.solicitacaoavulsa === 1) {
            suprimentosChildren.push({
              title: 'Solicitação Avulso',
              href: '/suprimentos/solicitacao-avulso',
              icon: <Icon.Disc />,
              id: 4.5,
              collapisble: false,
            });
          }

          if (suprimentosChildren.length > 0) {
            items.push({
              title: 'Suprimentos',
              href: '/suprimentos',
              id: 4,
              suffixColor: 'bg-primary',
              icon: <Icon.Grid />,
              collapisble: true,
              children: suprimentosChildren,
            });
          }
        }

        // Clientes
        const hasClientPermissions =
          permissionstorage?.ericacionamento === 1 ||
          permissionstorage?.ericadicional === 1 ||
          permissionstorage?.ericcontrolelpu === 1 ||
          permissionstorage?.ericrelatorio === 1 ||
          permissionstorage?.ericfechamento === 1 ||
          permissionstorage?.huaacionamento === 1 ||
          permissionstorage?.huaadicional === 1 ||
          permissionstorage?.huacontrolelpu === 1 ||
          permissionstorage?.huarelatorio === 1 ||
          permissionstorage?.huafechamento === 1 ||
          permissionstorage?.zteacionamento === 1 ||
          permissionstorage?.zteadicional === 1 ||
          permissionstorage?.ztecontrolelpu === 1 ||
          permissionstorage?.zterelatorio === 1 ||
          permissionstorage?.ztefechamento === 1 ||
          permissionstorage?.coscontrole === 1 ||
          permissionstorage?.coscontrolelpu === 1 ||
          permissionstorage?.cosrelatorio === 1 ||
          permissionstorage?.cosfechamento === 1 ||
          permissionstorage?.telefonicafechamento ||
          permissionstorage?.telefonicacontrole === 1 ||
          permissionstorage?.telefonicacontrolelpu === 1 ||
          permissionstorage?.telefonicarelatorio === 1;

        if (hasClientPermissions) {
          const clientesChildren = [];

          // Ericsson
          if (
            permissionstorage?.ericacionamento === 1 ||
            permissionstorage?.ericadicional === 1 ||
            permissionstorage?.ericcontrolelpu === 1 ||
            permissionstorage?.ericfechamento === 1 ||
            permissionstorage?.ericrelatorio === 1
          ) {
            clientesChildren.push({
              title: 'Ericsson',
              href: '/cliente/ericsson',
              icon: <Icon.Disc />,
              id: 5.1,
              collapisble: false,
            });
          }

          // Huawei
          if (
            permissionstorage?.huaacionamento === 1 ||
            permissionstorage?.huaadicional === 1 ||
            permissionstorage?.huafechamento === 1 ||
            permissionstorage?.huacontrolelpu === 1 ||
            permissionstorage?.huarelatorio === 1
          ) {
            clientesChildren.push({
              title: 'Huawei',
              href: '/cliente/huawei',
              icon: <Icon.Disc />,
              id: 5.2,
              collapisble: false,
            });
          }

          // ZTE
          if (
            permissionstorage?.zteacionamento === 1 ||
            permissionstorage?.zteadicional === 1 ||
            permissionstorage?.ztecontrolelpu === 1 ||
            permissionstorage?.ztefechamento === 1 ||
            permissionstorage?.zterelatorio === 1
          ) {
            clientesChildren.push({
              title: 'ZTE',
              href: '/cliente/zte',
              icon: <Icon.Disc />,
              id: 5.3,
              collapisble: false,
            });
          }

          // Cosmx
          if (
            permissionstorage?.coscontrole === 1 ||
            permissionstorage?.coscontrolelpu === 1 ||
            permissionstorage?.cosfechamento === 1 ||
            permissionstorage?.cosrelatorio === 1
          ) {
            clientesChildren.push({
              title: 'Cosmx',
              href: '/cliente/cosmx',
              icon: <Icon.Disc />,
              id: 5.4,
              collapisble: false,
            });
          }

          // Telefonica
          if (
            permissionstorage?.telefonicacontrole === 1 ||
            permissionstorage?.telefonicacontrolelpu === 1 ||
            permissionstorage?.telefonicafechamento === 1 ||
            permissionstorage?.telefonicarelatorio === 1
          ) {
            clientesChildren.push({
              title: 'Telefonica',
              href: '/cliente/telefonica',
              icon: <Icon.Disc />,
              id: 5.5,
              collapisble: false,
            });
          }

          if (clientesChildren.length > 0) {
            items.push({
              title: 'Clientes',
              href: '/cliente',
              id: 5,
              suffixColor: 'bg-primary',
              icon: <Icon.Trello />,
              collapisble: true,
              children: clientesChildren,
            });
          }
        }

        // Configurações
        if (permissionstorage?.controleacesso === 1) {
          items.push({
            title: 'Configurações',
            href: '/configuracao',
            icon: <Icon.Settings />,
            id: 10,
            collapisble: true,
            children: [
              {
                title: 'Controle de Acesso',
                href: '/configuracao/controleacesso',
                icon: <Icon.Disc />,
                id: 10.1,
                collapisble: false,
              },
            ],
          });
        }

        setMenuItems(items);
      } catch (error) {
        console.error('Error loading sidebar data:', error);
        setMenuItems([]);
      }
    };

    loadSidebarData();

    window.addEventListener('storage', (e) => {
      if (e.key === 'permission') {
        loadSidebarData();
      }
    });

    return () => {
      window.removeEventListener('storage', loadSidebarData);
    };
  }, []);

  return menuItems;
};

export default SidebarData;
