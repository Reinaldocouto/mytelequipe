import { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  GridActionsCellItem,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import EditIcon from '@mui/icons-material/Edit';
//import DeleteIcon from '@mui/icons-material/Delete';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import Rollouttelefonicaedicao from './rollout/Rollouttelefonicaedicao';
import Excluirregistro from '../Excluirregistro';

const Rollouttelefonica = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [totalacionamento, settotalacionamento] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [titulo, settitulo] = useState('');
  const [pmuf, setpmuf] = useState('');
  const [idr, setidr] = useState('');
  const [idpmtslocal, setidpmtslocal] = useState('');

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listarollouttelefonica = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/rollouttelefonica', { params });
      settotalacionamento(response.data);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  /* function deleteUser(stat) {
    setididentificador(stat);
    settelaexclusao(true);
    listarollouttelefonica();
  } */

  function alterarUser(stat, pmuflocal, idrlocal, ipmts) {
    settitulo('Editar Rollout Telefonica');
    setididentificador(stat);
    setpmuf(pmuflocal);
    setidr(idrlocal);
    settelacadastroedicao(true);
    setidpmtslocal(ipmts);
    console.log(ipmts);
  }

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          hint="Alterar"
          onClick={() =>
            alterarUser(
              parametros.row.uididcpomrf,
              parametros.row.pmoregional,
              parametros.row.id,
              parametros.row.uididpmts,
            )
          }
        />,
        /*    <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />, */
      ],
    },
    // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
    /* {
      field: 'pmts',
      headerName: 'PMTS',
      width: 80,
      align: 'center',
      type: 'string',
      editable: false,
    }, */
    {
      field: 'sytex',
      headerName: 'SYTEX',
      width: 130,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmoref',
      headerName: 'PMO - REF',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmocategoria',
      headerName: 'PMO - CATEGORIA',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },

    {
      field: 'uididpmts',
      headerName: 'UID - IDPMTS',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'ufsigla',
      headerName: 'UF/SIGLA',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmosigla',
      headerName: 'PMO - SIGLA',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmouf',
      headerName: 'PMO - UF',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmoregional',
      headerName: 'PMO - REGIONAL',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cidade',
      headerName: 'CIDADE',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'eapautomatica',
      headerName: 'EAP - AUTOMATICA',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'regionaleapinfra',
      headerName: 'REGIONAL - EAP - INFRA ',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'statusmensaltx',
      headerName: 'STATUS-MENSAL-TX',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'masterobrastatusrollout',
      headerName: 'MASTEROBR-STATUS-ROLLOUT',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'regionallibsitep',
      headerName: 'REGIONAL-LIB-SITE-P',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'regionallibsiter',
      headerName: 'REGIONAL-LIB-SITE-R',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'equipamentoentregap',
      headerName: 'EQUIPAMENTO-ENTREGA-P',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'regionalcarimbo',
      headerName: 'REGIONAL-CARIMBO',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'rsorsasci',
      headerName: 'RSO-RSA-SCI',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'rsorsascistatus',
      headerName: 'RSO-RSA-SCI-STATUS',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'regionalofensordetalhe',
      headerName: 'REGIONAL-OFENSOR-DETALHE',
      width: 600,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'vendorvistoria',
      headerName: 'VENDOR-VISTORIA',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'vendorprojeto',
      headerName: 'VENDOR-PROJETO',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'vendorinstalador',
      headerName: 'VENDOR-INSTALADOR',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'vendorintegrador',
      headerName: 'VENDOR-INTEGRADOR',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmotecnequip',
      headerName: 'PMO-TECN-EQUIP',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmofreqequip',
      headerName: 'PMO-FREQ-EQUIP',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'uididcpomrf',
      headerName: 'UID-IDCPOMRF',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'statusobra',
      headerName: 'Status Obra',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'entregarequest',
      headerName: 'Entrega Request',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'entregaplan',
      headerName: 'Entrega Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'entregareal',
      headerName: 'Entrega Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'fiminstalacaoplan',
      headerName: 'Fim Instalação Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'fiminstalacaoreal',
      headerName: 'Fim Instalação Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'integracaoplan',
      headerName: 'Integração Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'integracaoreal',
      headerName: 'Integração Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'ativacao',
      headerName: 'Ativação',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'documentacao',
      headerName: 'Documentação',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'datainventariodesinstalacao',
      headerName: 'Inventário Desinstalação',
      width: 220,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'dtplan',
      headerName: 'DT Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'dtreal',
      headerName: 'DT Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'rollout',
      headerName: 'Rollout',
      width: 400,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'acionamento',
      headerName: 'Acionamento',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'nomedosite',
      headerName: 'Nome do SITE',
      width: 400,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'endereco',
      headerName: 'Endereço',
      width: 400,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'rsorsadetentora',
      headerName: 'RSO-RSA-DETENTORA',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'rsorsaiddetentora',
      headerName: 'RSO-RSA-ID-DETENTORA',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'resumodafase',
      headerName: 'Resumo da Fase',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'infravivo',
      headerName: 'Infra VIVO',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'equipe',
      headerName: 'Equipe',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'docaplan',
      headerName: 'DOCA PLAN',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'deliverypolan',
      headerName: 'Delivery Plan',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'ov',
      headerName: 'OV',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'acesso',
      headerName: 'ACESSO',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 't2instalacao',
      headerName: 'T2 INSTALAÇÃO',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'numerodareq',
      headerName: 'NUMERO DA REQ',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'numerot2',
      headerName: 'NUMERO T2',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pedido',
      headerName: 'PEDIDO',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 't2vistoria',
      headerName: 'T2 VISTORIA',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'numerodareqvistoria',
      headerName: 'NUMERO DA REQ',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'numerot2vistoria',
      headerName: 'NUMERO T2',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pedidovistoria',
      headerName: 'PEDIDO',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
  ];

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }
  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
        onChange={(event, value) => apiRef.current.setPage(value - 1)}
      />
    );
  }

  const toggle = () => {
    setshow(!show);
  };

  const iniciatabelas = () => {
    listarollouttelefonica();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  const formatarDataCompleta = (valor) => {
    if (!valor) return '';
    try {
      const date = new Date(valor);
      return Number.isNaN(date.getTime())
        ? valor
        : date.toLocaleString('pt-BR', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
          });
    } catch {
      return valor;
    }
  };

  const gerarexcel = () => {
    const excelData = totalacionamento.map((item) => ({
      PMTS: item.pmts,
      SYTEX: item.sytex,
      'PMO REF': item.pmoref,
      CATEGORIA: item.pmocategoria,
      UF: item.pmouf,
      'SIGLA PMO': item.pmosigla,
      'SIGLA UF': item.ufsigla,
      REGIONAL: item.pmoregional,
      CIDADE: item.cidade,
      'EAP AUTOMÁTICA': item.eapautomatica,
      'EAP INFRA': item.regionaleapinfra,
      'STATUS MENSAL': item.statusmensaltx,
      'STATUS OBRA': item.statusobra,
      'MASTER OBRA': item.masterobrastatusrollout,
      ATIVAÇÃO: formatarDataCompleta(item.ativacao),
      DOCUMENTAÇÃO: formatarDataCompleta(item.documentacao),
      'INTEGRAÇÃO PLAN': formatarDataCompleta(item.integracaoplan),
      'INTEGRAÇÃO REAL': formatarDataCompleta(item.integracaoreal),
      'FIM INSTALAÇÃO PLAN': formatarDataCompleta(item.fiminstalacaoplan),
      'FIM INSTALAÇÃO REAL': formatarDataCompleta(item.fiminstalacaoreal),
      'ENTREGA REQUEST': formatarDataCompleta(item.entregarequest),
      'ENTREGA PLAN': formatarDataCompleta(item.entregaplan),
      'ENTREGA REAL': formatarDataCompleta(item.entregareal),
      CARIMBO: formatarDataCompleta(item.regionalcarimbo),
      'LIB SITE P': formatarDataCompleta(item.regionallibsitep),
      'LIB SITE R': formatarDataCompleta(item.regionallibsiter),
      'EQUIPAMENTO ENTREGA P': formatarDataCompleta(item.equipamentoentregap),
      'T2 INSTALAÇÃO': item.t2instalacao,
      REQ: item.numerodareq,
      T2: item.numerot2,
      PEDIDO: item.pedido,
      'VISTORIA T2': item.t2vistoria,
      DETENTORA: item.rsorsadetentora,
      'CÓDIGO DETENTORA': item.rsorsaiddetentora,
      'RSORSA SCI': item.rsorsasci,
      'RSORSA STATUS': item.rsorsascistatus,
      EQUIPE: item.equipe,
      'VENDEDOR VISTORIA': item.vendorvistoria,
      'VENDEDOR PROJETO': item.vendorprojeto,
      'VENDEDOR INSTALADOR': item.vendorinstalador,
      'VENDEDOR INTEGRADOR': item.vendorintegrador,
      TECNOLOGIA: item.pmotecnequip,
      FREQ: item.pmofreqequip,
      'CPOM RF': item.uididcpomrf,
      ROLLOUT: item.rollout,
      ACIONAMENTO: item.acionamento,
      'NOME DO SITE': item.nomedosite,
      ENDEREÇO: item.endereco,
      'RESUMO DA FASE': item.resumodafase,
      'DOC PLAN': item.docplan,
      'DOC FATURAMENTO': item.docaplan,
      'DELIVERY PLAN': formatarDataCompleta(item.deliverypolan),
      ACESSO: item.acesso,
      'OBSERVAÇÃO ACESSO': item.acessoobs,
      DDD: item.ddd,
      LATITUDE: item.latitude,
      LONGITUDE: item.longitude,
      'DT PLAN': formatarDataCompleta(item.dtplan),
      'DT REAL': formatarDataCompleta(item.dtreal),
    }));
    exportExcel({ excelData, fileName: 'Relatorio_Total_acionamento' });
  };

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader>Rollout - Telefonica</ModalHeader>
        <ModalBody>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
              {telacadastroedicao ? (
                <>
                  {' '}
                  <Rollouttelefonicaedicao
                    show={telacadastroedicao}
                    setshow={settelacadastroedicao}
                    ididentificador={ididentificador}
                    atualiza={listarollouttelefonica}
                    pmuf={pmuf}
                    titulotopo={titulo}
                    idr={idr}
                    idpmtslocal={idpmtslocal}
                  />{' '}
                </>
              ) : null}

              {telaexclusao ? (
                <>
                  <Excluirregistro
                    show={telaexclusao}
                    setshow={settelaexclusao}
                    ididentificador={ididentificador}
                    quemchamou="ROLLOUTTELEFONICA"
                    atualiza={listarollouttelefonica}
                  />{' '}
                </>
              ) : null}

              <div className="row g-3">
                <div className="col-sm-3">
                  <Button color="link" onClick={gerarexcel}>
                    Exportar Excel
                  </Button>
                </div>
              </div>
              <br />
              <Box sx={{ height: '85%', width: '100%' }}>
                <DataGrid
                  rows={totalacionamento}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  sx={{
                    '& .MuiDataGrid-menuIconButton': {
                      color: 'white',
                    },

                    '& .MuiDataGrid-sortIcon': {
                      color: 'white', // Ícone de ordenação branco
                    },
                    '& .MuiDataGrid-columnHeaders': {
                      backgroundColor: '#f0f0f0', // Cor de fundo geral do cabeçalho
                      minHeight: '30px !important', // Define a altura mínima do cabeçalho
                      maxHeight: '30px !important', // Define a altura máxima do cabeçalho
                    },
                    '& .MuiDataGrid-columnHeader': {
                      minHeight: '30px !important',
                      maxHeight: '30px !important',
                      lineHeight: '30px !important',
                      padding: '0px 8px !important', // Remove o excesso de espaço interno
                    },
                    '& .MuiDataGrid-columnHeaderTitle': {
                      fontSize: '14px', // Ajusta o tamanho da fonte para caber melhor
                      lineHeight: '32px',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='pmts']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='sytex']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='pmoref']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='pmocategoria']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='uididpmts']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='ufsigla']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='pmosigla']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='pmouf']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='pmoregional']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='cidade']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='eapautomatica']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='regionaleapinfra']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='statusmensaltx']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='masterobrastatusrollout']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='regionallibsitep']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='regionallibsiter']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='equipamentoentregap']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='regionalcarimbo']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='rsorsasci']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='rsorsascistatus']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='regionalofensordetalhe']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='vendorvistoria']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='vendorprojeto']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='vendorinstalador']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='vendorintegrador']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='pmotecnequip']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='pmofreqequip']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='uididcpomrf']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='docaplan']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='deliverypolan']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='ov']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='nomedosite']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='endereco']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='rsorsadetentora']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='rsorsaiddetentora']": {
                      backgroundColor: '#000000', // preto
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='acesso']": {
                      backgroundColor: '#ff4d4d', // Vermelho
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='resumodafase']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='infravivo']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='equipe']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },

                    "& .MuiDataGrid-columnHeader[data-field='entregarequest']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='entregaplan']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='entregareal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='fiminstalacaoplan']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='fiminstalacaoreal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='integracaoplan']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='integracaoreal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='ativacao']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='documentacao']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='dtplan']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='dtreal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='rollout']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='statusobra']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acionamento']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='t2instalacao']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='numerodareq']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='numerot2']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='pedido']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='t2vistoria']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='numerodareqvistoria']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='numerot2vistoria']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='pedidovistoria']": {
                      backgroundColor: '#2196f3', // Azul
                      color: 'white',
                    },
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                />
              </Box>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggle}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Rollouttelefonica.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Rollouttelefonica;
