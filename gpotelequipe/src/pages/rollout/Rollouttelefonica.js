import React, { useMemo, useState, useEffect, useRef } from 'react';
import { Button, InputGroup, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
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
  useGridApiRef,
} from '@mui/x-data-grid';
import { ZipReader, BlobReader, BlobWriter } from '@zip.js/zip.js';
import EditIcon from '@mui/icons-material/Edit';
import AssignmentIcon from '@mui/icons-material/Assignment';
import DeleteIcon from '@mui/icons-material/Delete';
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import { ToastContainer, toast } from 'react-toastify';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import Rollouttelefonicaedicao from '../../components/formulario/rollout/Rollouttelefonicaedicao';
import FiltroRolloutTelefonica from '../../components/modals/FiltroRolloutTelefonica';
import Excluirregistro from '../../components/Excluirregistro';
import Telat2editar from '../../components/formulario/projeto/Telat2editar';
import ConfirmaModal from '../../components/modals/ConfirmacaoModal';
import AdicionarSiteManual from '../../components/formulario/rollout/AdicionarSiteManual';
import modoVisualizador from '../../services/modovisualizador';
import S3Service from '../../services/s3Service';
import createLocalDate from '../../services/data';

let s3Service;

const fetchS3Credentials = async () => {
  try {
    const response = await api.get('v1/credenciaiss3');
    if (response.status === 200) {
      const { acesskeyid, secretkey, region, bucketname } = response?.data[0];
      s3Service = new S3Service({
        region,
        accessKeyId: acesskeyid,
        secretAccessKey: secretkey,
        bucketName: bucketname,
      });
    } else {
      console.error('Credenciais do S3 não encontradas ou resposta malformada:', response.data);
    }
  } catch (error) {
    console.error('Erro ao buscar credenciais do S3:', error);
  }
};

const Rollouttelefonica = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(100);
  const [loading, setLoading] = useState(false);
  const [totalacionamento, settotalacionamento] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telacadastrot2edicao, settelacadastrot2edicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [titulo, settitulo] = useState('');
  const [titulot2, settitulot2] = useState('');
  const [pmuf, setpmuf] = useState('');
  const [idr, setidr] = useState('');
  const [idpmtslocal, setidpmtslocal] = useState('');
  const [show1, setshow1] = useState(false);
  const [idobra, setidobra] = useState('');
  const [idpmtdeletado, setidpmtdeletado] = useState('');
  const [paginationModel, setPaginationModel] = useState({
    pageSize: 100,
    page: 0,
  });
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [filter, setFilter] = useState({});
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [rowToUpdate, setRowToUpdate] = useState(null);
  const [file, setFile] = useState(null);
  const [showAdicionarSiteManual, setShowAdicionarSiteManual] = useState(false);
  const apiRef = useGridApiRef();
  const scrollerRef = useRef(null);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    ...filter,
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
      const savedPos = localStorage.getItem('gridScrollPos');
      console.log(savedPos);
      if (savedPos) {
        const { top, left } = JSON.parse(savedPos);
        requestAnimationFrame(() => {
          if (apiRef?.current?.scroll) apiRef.current.scroll({ top, left });
        });
      }
    }
  };
  const marcarComoAvulso = async () => {
    if (!rowSelectionModel.length) {
      toast.warning('Selecione pelo menos um item para marcar como avulso.');
      return;
    }
    setLoading(true);
    try {
      // Filtra os IDs das atividades selecionadas
      const atividadeSelecionada = totalacionamento
        .filter((item) => rowSelectionModel.includes(item.id))
        .map((item) => item.uididpmts)
        .join(',');

      await api.post('v1/projetotelefonica/marcaravulso', {
        ...params,
        uuidps: atividadeSelecionada,
      });

      toast.success('Itens marcados como avulso com sucesso!');
      listarollouttelefonica();
    } catch (error) {
      console.error('Erro ao marcar como avulso:', error);
      toast.error('Falha ao marcar como avulso.');
    } finally {
      setLoading(false);
    }
  };
  const desmarcarComoAvulso = async () => {
    if (!rowSelectionModel.length) {
      toast.warning('Selecione pelo menos um item para desmarcar como avulso.');
      return;
    }
    setLoading(true);
    try {
      // Filtra os IDs das atividades selecionadas
      const atividadeSelecionada = totalacionamento
        .filter((item) => rowSelectionModel.includes(item.id))
        .map((item) => item.uididpmts)
        .join(',');

      await api.post('v1/projetotelefonica/desmarcarComoAvulso', {
        ...params,
        uuidps: atividadeSelecionada,
      });

      toast.success('Itens marcados como avulso com sucesso!');
      listarollouttelefonica();
    } catch (error) {
      console.error('Erro ao marcar como avulso:', error);
      toast.error('Falha ao marcar como avulso.');
    } finally {
      setLoading(false);
    }
  };
  const listaFilterrollouttelefonica = async (items) => {
    try {
      setLoading(true);
      const response = await api.get('v1/rollouttelefonica', { params, ...items });
      settotalacionamento(response.data);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function deleteUser(stat) {
    setididentificador(stat);
    settelaexclusao(true);
    listarollouttelefonica();
  }

  function alterarUser(stat, pmuflocal, idrlocal, ipmts, delet) {
    settitulo('Editar Rollout Telefonica');
    setididentificador(stat);
    setpmuf(pmuflocal);
    setidr(idrlocal);
    settelacadastroedicao(true);
    setidpmtslocal(ipmts);
    setidpmtdeletado(delet);
    console.log(ipmts);
  }

  function t2editar(stat, pmuflocal, idrlocal, ipmts) {
    setididentificador(stat);
    setpmuf(pmuflocal);
    setidr(idrlocal);
    settelacadastrot2edicao(true);
    setidpmtslocal(ipmts);
    settitulot2(`T2 - ${ipmts}`);
    setidobra(stat);
  }

  const handleProcessRowUpdateError = (error) => {
    console.error('Erro ao salvar:', error);
    setmensagem('Erro ao salvar a edição!');
  };
  const columnsRaw = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 100,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          name="Alterar"
          hint="Alterar"
          onClick={() =>
            alterarUser(
              parametros.row.uididcpomrf,
              parametros.row.pmoregional,
              parametros.row.id,
              parametros.row.uididpmts,
              parametros.row.deletado,
            )
          }
        />,
        <GridActionsCellItem
          icon={<AssignmentIcon />}
          label="T2"
          hint="T2"
          onClick={() =>
            t2editar(
              parametros.row.uididcpomrf,
              parametros.row.pmoregional,
              parametros.row.id,
              parametros.row.uididpmts,
            )
          }
        />,
        // Botão de exclusão apenas para sites manuais
        ...(parametros.row.origem === 'Manual'
          ? [
              <GridActionsCellItem
                icon={<DeleteIcon />}
                label="Excluir"
                hint="Excluir Site Manual"
                onClick={() => deleteUser(parametros.row.id)}
                sx={{ color: 'red' }}
              />,
            ]
          : []),
      ],
    },
    // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
    
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
      field: 'regionalpreaceiteeap',
      headerName: 'REGIONAL-PRE-ACEITE-EAP',
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
      field: 'regionalpreaceiteresponsavel',
      headerName: 'REGIONAL-PRE-ACEITE-RESPONSAVEL',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'pmoaceitacaop',
      headerName: 'PMO - ACEITACAO P',
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
      field: 'pmoaceitacaor',
      headerName: 'PMO - ACEITACAO R',
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
      field: 'pmoaceitacao',
      headerName: 'PMO-ACEITACAO',
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
      field: 'statusmensaltx',
      headerName: 'STATUS-MENSAL-TX',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'pmoaceitacaop',
      headerName: 'PMO Aceitação Plan',
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
      field: 'pmoaceitacaor',
      headerName: 'PMO Aceitação Real',
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
      valueGetter: (parametros) => createLocalDate(parametros.value),
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
      valueGetter: (parametros) => createLocalDate(parametros.value),
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
      valueGetter: (parametros) => createLocalDate(parametros.value),
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
      valueGetter: (parametros) => createLocalDate(parametros.value),
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
      type: 'singleSelect',
      editable: true,
      valueOptions: [
        'APROVADO',
        'REPROVADO',
        'AGENDAR',
        'AG. TX',
        'ATIVAÇÃO',
        'CANCELADO',
        'CONCLUIDO',
        'DT',
        'ENTREGA',
        'INSTALAÇÃO',
        'INTEGRAÇÃO',
        'PARALISADO',
        'PLANEJAMENTO',
        'PROG. INTEGRAÇÃO',
        'VISTORIA',
      ],
    },

    {
      field: 'vistoriaplan',
      headerName: 'Vistoria Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'vistoriareal',
      headerName: 'Vistoria Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'docplan',
      headerName: 'Documentação Vistoria Plan',
      width: 200,
      align: 'left',
      type: 'date',
      editable: true,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = createLocalDate(parametros.value);
        if (!date) return '';

        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }
        if (
          date.getDate() === 29 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'docvitoriareal',
      headerName: 'Documentação Vistoria Real',
      width: 200,
      align: 'left',
      type: 'date',
      editable: true,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = createLocalDate(parametros.value);
        if (!date) return '';

        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }
        if (
          date.getDate() === 29 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'req',
      headerName: 'REQ',
      width: 200,
      align: 'left',
      type: 'date',
      editable: true,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = createLocalDate(parametros.value);
        if (!date) return '';

        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }
        if (
          date.getDate() === 29 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'entregaplan',
      headerName: 'Entrega Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'entregareal',
      headerName: 'Entrega Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'fiminstalacaoplan',
      headerName: 'Fim Instalação Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'fiminstalacaoreal',
      headerName: 'Fim Instalação Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'integracaoplan',
      headerName: 'Integração Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'integracaoreal',
      headerName: 'Integração Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },

    {
      field: 'ativacao',
      headerName: 'Ativação Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'documentacao',
      headerName: 'Documentação',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
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
      editable: true,
    },

    {
      field: 'initialtunningreal',
      headerName: 'Initial Tunning Real Início',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: ({ value }) => {
        if (!value) return null;
        const data = createLocalDate(value);
        if (!data) return null;
        data.setDate(data.getDate() + 1); // Corrige o deslocamento
        return data;
      },
      valueFormatter: ({ value }) =>
        value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(value) : '',

      editable: !modoVisualizador(),
    },
    {
      field: 'initialtunningrealfinal',
      headerName: 'Initial Tunning Real Final',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: ({ value }) => {
        if (!value) return null;
        const data = new Date(value);
        data.setDate(data.getDate() + 1);
        return data;
      },
      valueFormatter: ({ value }) =>
        value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(value) : '',
      editable: !modoVisualizador(),
    },
    {
      field: 'initialtunnigstatus',
      headerName: 'Initial Tunning Status',
      width: 250,
      align: 'left',
      type: 'singleSelect', // muda de string para singleSelect
      editable: true,
      valueOptions: ['ABERTA', 'COMPLETADO_COM_PENDENCIAS', 'COMPLETADO'], // opções do dropdown
    },
    {
      field: 'aprovacaossv',
      headerName: 'Aprovação de SSV',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: ({ value }) => {
        if (!value) return null;
        const data = new Date(value);
        data.setDate(data.getDate() + 1);
        return data;
      },
      valueFormatter: ({ value }) =>
        value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(value) : '',
      editable: !modoVisualizador(),
    },
    {
      field: 'statusaprovacaossv',
      headerName: 'Status Aprovação de SSV',
      width: 220,
      align: 'left',
      type: 'singleSelect',
      editable: !modoVisualizador(),
      valueOptions: ['APROVADO', 'REPROVADO'],
    },
    {
      field: 'dtplan',
      headerName: 'DT Plan',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'dtreal',
      headerName: 'DT Real',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'dataimprodutiva',
      headerName: 'Data Improdutiva',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },

    /*    {
      field: 'entregarequest',
      headerName: 'Entrega Request',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },*/

    {
      field: 'acompanhamentofisicoobservacao',
      headerName: 'Acompanhamento Físico\nObservação',
      width: 400,
      align: 'left',
      type: 'string',
      editable: true,
      renderCell: (cellParams) => <div style={{ whiteSpace: 'pre-wrap' }}>{cellParams.value}</div>,
    },
    {
      field: 'rollout',
      headerName: 'Rollout',
      width: 400,
      align: 'left',
      type: 'string',
      editable: true,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'acionamento',
      headerName: 'Acionamento',
      width: 250,
      align: 'left',
      type: 'string',
      editable: true,
    },
    {
      field: 'nomedosite',
      headerName: 'Nome do SITE',
      width: 400,
      align: 'left',
      type: 'string',
      editable: true,
    },
    {
      field: 'endereco',
      headerName: 'Endereço',
      width: 400,
      align: 'left',
      type: 'string',
      editable: true,
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
      field: 'origem',
      headerName: 'Origem',
      width: 120,
      align: 'center',
      type: 'string',
      editable: false,
      renderCell: (parametros) => (
        <div
          style={{
            backgroundColor: parametros.value === 'Manual' ? '#28a745' : '#007bff',
            color: 'white',
            padding: '4px 8px',
            borderRadius: '4px',
            fontSize: '12px',
            fontWeight: 'bold',
            textAlign: 'center',
            width: '100%',
          }}
        >
          {params.value || 'PMTS'}
        </div>
      ),
    },
    {
      field: 'avulso',
      headerName: 'Avulso',
      width: 120,
      align: 'center',
      type: 'string',
      editable: false,
      renderCell: (parametros) => {
        const valor = parametros.value; // 0 ou 1
        const ehAvulso = valor === 1;

        return (
          <div
            style={{
              backgroundColor: ehAvulso ? '#28a745' : '#dc3545', // verde se Sim, vermelho se Não
              color: 'white',
              padding: '4px 8px',
              borderRadius: '4px',
              fontSize: '12px',
              fontWeight: 'bold',
              textAlign: 'center',
              width: '100%',
            }}
          >
            {ehAvulso ? 'Sim' : 'Não'}
          </div>
        );
      },
    },
    {
      field: 'datapostagemdoc',
      headerName: 'Data de Postagem Doc.',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'dataexecucaodoc',
      headerName: 'Data de Execução Doc',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'datapostagemdocvdvm',
      headerName: 'Data de Postagem Doc. VD/VM',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'dataexecucaodocvdvm',
      headerName: 'Data de Execução Doc. VD/VM',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },
    {
      field: 'statusdocumentacao',
      headerName: 'Status Relatório Fotográfico',
      width: 200,
      align: 'left',
      type: 'singleSelect',
      editable: true,
      valueOptions: ['Aprovado', 'Em Progresso', 'Incompleto', 'Reprovado'],
    },
    {
      field: 'infra',
      headerName: 'Infra',
      width: 150,
      align: 'left',
      editable: true,
      type: 'singleSelect',
      valueOptions: [
        'CAMUFLADO',
        'GREENFIELD',
        'INDOOR',
        'MASTRO',
        'POSTE METÁLICO',
        'ROOFTOP',
        'TORRE METALICA',
        'SLS',
      ],
    },
    {
      field: 'acessoatividade',
      headerName: 'Atividade',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessocomentario',
      headerName: 'Comentários',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessooutros',
      headerName: 'Outros',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessoformaacesso',
      headerName: 'Forma de Acesso',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'ddd',
      headerName: 'DDD',
      width: 80,
      align: 'center',
      editable: true,
    },
    {
      field: 'latitude',
      headerName: 'Latitude',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'longitude',
      headerName: 'Longitude',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessoobs',
      headerName: 'Acesso OBS',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessosolicitacao',
      headerName: 'Acesso Solicitação',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessodatasolicitacao',
      headerName: 'Data Solicitação',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (acessoDataSolicitacao) =>
        acessoDataSolicitacao.value ? createLocalDate(acessoDataSolicitacao.value) : null,
      valueFormatter: (acessoDataSolicitacao) =>
        acessoDataSolicitacao.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(
              acessoDataSolicitacao.value,
            )
          : '',
      editable: true,
    },
    {
      field: 'acessodatainicial',
      headerName: 'Data Inicial',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (acessodatainicial) =>
        acessodatainicial.value ? createLocalDate(acessodatainicial.value) : null,
      valueFormatter: (acessodatainicial) =>
        acessodatainicial.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(params.value)
          : '',
      editable: true,
    },
    {
      field: 'acessodatafinal',
      headerName: 'Data Final',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (acessodatafinal) =>
        acessodatafinal.value ? createLocalDate(acessodatafinal.value) : null,
      valueFormatter: (acessodatafinal) =>
        acessodatafinal.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(acessodatafinal.value)
          : '',
      editable: true,
    },
    {
      field: 'acessostatus',
      headerName: 'Status',
      width: 150,
      align: 'left',
      type: 'singleSelect',
      editable: true,
      valueOptions: [
        'AGUARDANDO',
        'CANCELADO',
        'CONCLUIDO',
        'LIBERADO',
        'PEDIR',
        'REJEITADO',
        'SSV ENTREGUE',
      ],
    },
    {
      field: 'initialtunningrealfinal',
      headerName: 'Initial Tunning Real Final',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: ({ value }) => createLocalDate(value),
      valueFormatter: ({ value }) =>
        value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(value) : '',
      editable: !modoVisualizador(),
    },
    {
      field: 'dataimprodutiva',
      headerName: 'Data Improdutiva',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: true,
    },

    {
      field: 'aprovacaossv',
      headerName: 'Aprovação de SSV',
      width: 200,
      align: 'left',
      type: 'date',
      valueGetter: ({ value }) => {
        if (!value) return null;
        const data = createLocalDate(value);
        if (!data) return null;
        data.setDate(data.getDate() + 1);
        return data;
      },
      valueFormatter: ({ value }) =>
        value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(value) : '',
      editable: !modoVisualizador(),
    },
    {
      field: 'statusaprovacaossv',
      headerName: 'Status Aprovação de SSV',
      width: 220,
      align: 'left',
      type: 'singleSelect',
      editable: !modoVisualizador(),
      valueOptions: ['APROVADO', 'REPROVADO'],
    },
  ];

  // Remove duplicados pelo campo 'field'
  const columns = useMemo(() => {
    const seen = new Set();
    return columnsRaw.filter((col) => {
      if (seen.has(col.field)) return false;
      seen.add(col.field);
      return true;
    });
  }, [columnsRaw]);

  const handleConfirmSave = async () => {
    if (!rowSelectionModel.length) {
      console.warn('Nenhuma atividade selecionada.');
      return;
    }

    setLoading(true);

    try {
      // Filtra os IDs das atividades selecionadas
      const atividadeSelecionada = totalacionamento
        .filter((item) => rowSelectionModel.includes(item.id))
        .map((item) => item.uididpmts)
        .join(',');

      // Espera a resposta da API
      const field = rowToUpdate?.changedFields?.[0];
      if (!field) {
        throw new Error('Campo de atualização não identificado');
      }
      let value = rowToUpdate?.newRow?.[field];
      if (field === 'dataimprodutiva' && value) {
        const date = new Date(value);
        value = !Number.isNaN(date.getTime()) ? date.toISOString().split('T')[0] : null;
      }
      const response = await api.post('v1/projetotelefonica/editaremmassa', {
        ...params,
        uuidps: atividadeSelecionada,
        [rowToUpdate.changedFields[0]]: value,
      });

      // Opcional: log de sucesso
      console.log('Alterações salvas com sucesso:', response.data);

      // Fecha o modal e atualiza a lista

      listarollouttelefonica();
    } catch (error) {
      console.error('Erro ao salvar alterações em massa:', error);
      // Opcional: mostrar feedback visual ao usuário
      toast.error('Falha ao salvar alterações.');
    } finally {
      setLoading(false);
      setConfirmOpen(false);
    }
  };

  const handleCancelSave = () => {
    console.log('Cancelado pelo usuário.');
    setConfirmOpen(false);
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  function CustomPagination() {
    const apiRefPage = useGridApiContext();
    const page = useGridSelector(apiRefPage, gridPageSelector);
    const pageCount = useGridSelector(apiRefPage, gridPageCountSelector);
    const rowCount = apiRefPage.current.getRowsCount(); // Obtém total de itens
    return (
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          padding: '10px',
        }}
      >
        <Typography variant="body2">Total de itens: {rowCount}</Typography>

        <Pagination
          color="primary"
          count={pageCount}
          page={page + 1}
          onChange={(event, value1) => apiRefPage.current.setPage(value1 - 1)}
        />
      </Box>
    );
  }

  const toggle = () => {
    setshow(!show);
  };

  const toggle1 = () => {
    setshow1(!show1);
  };

  useEffect(() => {
    // Função para configurar listener de scroll
    const setupScrollListener = () => {
      const scroller = document.querySelector('.MuiDataGrid-virtualScroller');
      if (!scroller) return; // ainda não renderizou
      scrollerRef.current = scroller;

      // Restaura posição salva
      const savedPos = localStorage.getItem('gridScrollPos');
      if (savedPos) {
        const { top, left } = JSON.parse(savedPos);
        scroller.scrollTop = top;
        scroller.scrollLeft = left;
      }

      // Remove listener antigo se existir
      scroller.removeEventListener('scroll', scrollerRef.current.handleScroll);

      // Cria novo listener para salvar scroll sempre que ele mudar
      scrollerRef.current.handleScroll = () => {
        localStorage.setItem(
          'gridScrollPos',
          JSON.stringify({ top: scroller.scrollTop, left: scroller.scrollLeft }),
        );
      };

      scroller.addEventListener('scroll', scrollerRef.current.handleScroll);
    };

    // Tenta configurar várias vezes até o scroller existir
    const interval = setInterval(() => {
      setupScrollListener();
      if (scrollerRef.current) clearInterval(interval);
    }, 50);

    return () => {
      clearInterval(interval);
      // remove listener se existir
      if (scrollerRef.current) {
        scrollerRef.current.removeEventListener('scroll', scrollerRef.current.handleScroll);
      }
    };
  }, [totalacionamento]);

  const iniciatabelas = () => {
    listarollouttelefonica();
    fetchS3Credentials();
  };

  const chamarfiltro = () => {
    setshow1(true);
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  /* ---------- helpers -------------------------------------------------- */
  const dateFields = new Set([
    // já existentes
    'ENTRGA_REQUEST',
    'ENTREGA_PLAN',
    'ENTREGA_REAL',
    'FIM_INSTALACAO_PLAN',
    'FIM_INSTALACAO_REAL',
    'INTEGRACAO_PLAN',
    'INTEGRACAO_REAL',
    'DT_PLAN',
    'DT_REAL',
    'DELIVERY_PLAN',
    'DATA_IMPRODUTIVA',
    'REGIONAL_LIB_SITE_P',
    'REGIONAL_LIB_SITE_R',
    'EQUIPAMENTO_ENTREGA_P',
    'REGIONAL_CARIMBO',
    'PMO_ACEITACAO',
    'PMO_ACEITACAO_P',
    'PMO_ACEITACAO_R',
    'REGIONAL_PRE_ACEITE_EAP',
    'ATIVACAO_REAL',
    'DOCUMENTACAO',
    'INITIAL_TUNNING_REAL',
    'INITIAL_TUNNING_REAL_FINAL',
    'APROVACAO_SSV',
    'INITIAL_TUNNING_STATUS',
    'VISTORIA_PLAN',
    'VISTORIA_REAL',
    'DOCUMENTACAO_VISTORIA_PLAN',
    'DOCUMENTACAO_VISTORIA_REAL',
    'REQ',
  ]);

  const toBRDate = (v) => {
    if (!v) return v;
    // “datas nulas” → vazio
    if (/^(1899-12-(30|31)|0000-00-00)/.test(v)) return '';

    // Usar createLocalDate para criar a data corretamente
    const d = createLocalDate(v);
    if (d && !Number.isNaN(d.getTime())) return d.toLocaleDateString('pt-BR'); // 28/04/2025

    // dd/mm/aaaa ou dd-mm-aaaa
    const br = typeof v === 'string' && v.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/);
    if (br) {
      const [, dd, mm, yyyy] = br;
      const normal = `${dd.padStart(2, '0')}/${mm.padStart(2, '0')}/${yyyy}`;
      if (normal === '31/12/1899' || normal === '30/12/1899') return '';
      return normal;
    }
    return v; // valor não reconhecido
  };

  const formatDatesBR = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, dateFields.has(k) ? toBRDate(v) : v]),
    );

  const upperStrings = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, typeof v === 'string' ? v.toUpperCase() : v]),
    );

  /* ---------- função principal ---------------------------------------- */
  const gerarexcel = () => {
    const excelData = totalacionamento
      .map((item) => ({
       
        'PMO - REF': item.pmoref,
        'PMO - CATEGORIA': item.pmocategoria,
        UIDIDPMTS: item.uididpmts,
        UFSIGLA: item.ufsigla,
        PMOSIGLA: item.pmosigla,
        PMOUF: item.pmouf,
        PMOREGIONAL: item.pmoregional,
        CIDADE: item.cidade,
        EAPAUTOMATICA: item.eapautomatica,
        REGIONAL_EAP_INFRA: item.regionaleapinfra,
        REGIONAL_PRE_ACEITE_EAP: item.regionalpreaceiteeap,
        REGIONAL_PRE_ACEITE_RESPONSAVEL: item.regionalpreaceiteresponsavel,
        PMO_ACEITACAO_P: item.pmoaceitacaop,
        PMO_ACEITACAO_R: item.pmoaceitacaor,
        PMO_ACEITACAO: item.pmoaceitacao,
        STATUS_MENSAL_TX: item.statusmensaltx,
        MASTEROBR_STATUS_ROLLOUT: item.masterobrastatusrollout,
        REGIONAL_LIB_SITE_P: item.regionallibsitep,
        REGIONAL_LIB_SITE_R: item.regionallibsiter,
        EQUIPAMENTO_ENTREGA_P: item.equipamentoentregap,
        REGIONAL_CARIMBO: item.regionalcarimbo,
        RSORSA_SCI: item.rsorsasci,
        RSORSA_SCI_STATUS: item.rsorsascistatus,
        REGIONAL_OFENSOR_DETALHE: item.regionalofensordetalhe,
        VENDOR_VISTORIA: item.vendorvistoria,
        VENDOR_PROJETO: item.vendorprojeto,
        VENDOR_INSTALADOR: item.vendorinstalador,
        VENDOR_INTEGRADOR: item.vendorintegrador,
        PMO_TECN_EQUIP: item.pmotecnequip,
        PMO_FREQ_EQUIP: item.pmofreqequip,
        UID_IDCPOMRF: item.uididcpomrf,
        STATUS_OBRA: item.statusobra,
        VISTORIA_PLAN: item.vistoriaplan,
        VISTORIA_REAL: item.vistoriareal,
        DOCUMENTACAO_VISTORIA_PLAN: item.docplan,
        DOCUMENTACAO_VISTORIA_REAL: item.docvitoriareal,
        REQ: item.req,
        ENTREGA_PLAN: item.entregaplan,
        ENTREGA_REAL: item.entregareal,
        FIM_INSTALACAO_PLAN: item.fiminstalacaoplan,
        FIM_INSTALACAO_REAL: item.fiminstalacaoreal,
        INTEGRACAO_PLAN: item.integracaoplan,
        INTEGRACAO_REAL: item.integracaoreal,
        ATIVACAO_REAL: item.ativacao,
        DOCUMENTACAO: item.documentacao,
        INVENTARIO_DESINSTALACAO: item.datainventariodesinstalacao,
        DATA_IMPRODUTIVA: item.dataimprodutiva,
        INITIAL_TUNNING_REAL: item.initialtunningreal,
        INITIAL_TUNNING_REAL_FINAL: item.initialtunningrealfinal,
        APROVACAO_SSV: item.aprovacaossv,
        STATUS_APROVACAO_SSV: item.statusaprovacaossv,
        INITIAL_TUNNING_STATUS: item.initialtunningstatus,
        DT_PLAN: item.dtplan,
        DT_REAL: item.dtreal,
        OBSERVACAO: item.acompanhamentofisicoobservacao,
        ROLLOUT: item.rollout,
        ACIONAMENTO: item.acionamento,
        NOME_DO_SITE: item.nomedosite,
        ENDERECO: item.endereco,
        RSORSA_DETENTORA: item.rsorsadetentora,
        RSORSA_ID_DETENTORA: item.rsorsaiddetentora,
        RESUMO_DA_FASE: item.resumodafase,
        INFRA_VIVO: item.infravivo,
        EQUIPE: item.equipe,
        DOCA_PLAN: item.docaplan,
        DELIVERY_PLAN: item.deliverypolan,
        OV: item.ov,
        ACESSO: item.acesso,
        ORIGEM: item.origem || 'PMTS',
        AVULSO: item.avulso === 1 ? 'SIM' : 'NÃO',
        DELETADO: item.deletado === 1 ? 'SIM' : 'NÃO',
      }))
      .map(formatDatesBR) // 1. converte datas / zera 1899-12-xx
      .map(upperStrings); // 2. caixa-alta

    exportExcel({ excelData, fileName: 'ROLLOUT TELEFONICA' });
  };
  const [changedField, setChangedField] = useState(null);

  const handleFileUpload = async () => {
    if (!file) return;

    try {
      const reader = new ZipReader(new BlobReader(file));
      const entries = await reader.getEntries();

      if (!entries.length) throw new Error('ZIP está vazio');

      await Promise.all(
        entries.map(async (entry) => {
          // Regex para BA\d+ ou SP\d+
          const match = entry.filename.match(/(?:-|_)(BA\d+|[A-Z]{2}\d+)/);
          if (!match) {
            console.warn(`Código não encontrado em: ${entry.filename}`);
            return;
          }

          const identificador = match[1] || match[0];
          const prefix = `telequipe/rollout/${identificador}/`;

          // Lista e remove arquivos existentes no S3
          const existingFiles = await s3Service.listFiles(prefix);
          if (existingFiles.length > 0) {
            await Promise.all(
              existingFiles
                .filter((fileItem) => fileItem.Key)
                .map((fileMap) => s3Service.deleteFile(fileMap.Key)),
            );
          }

          const blob = await entry.getData(new BlobWriter());
          const innerFile = new File([blob], entry.filename);
          const key = `${prefix}${entry.filename}`;
          await s3Service.uploadFile(innerFile, key);
        }),
      );

      setFile(null);
      toast.success('Arquivo anexado com sucesso!');
      await reader.close();
    } catch (error) {
      console.error('Erro ao processar ZIP', error);
      toast.error(`Erro ao subir arquivo: ${error}`);
      setFile(null);
    }
  };

  const handleChange = async (event) => {
    const filelocal = event.target.files[0];
    if (!filelocal) return;

    try {
      const reader = new ZipReader(new BlobReader(filelocal));
      const entries = await reader.getEntries();

      // Pega apenas os nomes dos arquivos
      const filesInside = entries.map((e) => e.filename);

      const invalidFiles = filesInside.filter((name) => !/([A-Z]{2}\d+)/.test(name));
      console.log(invalidFiles);
      if (invalidFiles.length > 1) {
        toast.warning(`Arquivos sem identificador encontrado:\n${invalidFiles.join('\n')}`);
        return;
      }

      const sites = filesInside
        .map((name) => {
          const match = name.match(/BA\d+|[A-Z]{2}\d+/);
          return match ? match[0] : null;
        })
        .filter(Boolean);

      console.log('Sites extraídos:', sites);

      toast.success('ZIP validado com sucesso!');
      setFile(filelocal);
      await reader.close();
    } catch (error) {
      console.error('Erro ao validar ZIP', error);
      toast.error('Erro ao processar arquivo ZIP grande');
    }
  };

  const handleProcessRowUpdate = async (newRow, oldRow) => {
    if (rowSelectionModel.length === 0) {
      setmensagem('Selecione pelo menos um item');
      return oldRow;
    }

    const isEqual = (a, b) => {
      if (a instanceof Date && b instanceof Date) {
        return a.getTime() === b.getTime();
      }
      return a === b;
    };

    const changedFields = Object.keys(newRow).filter((key) => {
      if (key === 'id') return false;
      return !isEqual(newRow[key], oldRow[key]);
    });

    if (changedFields.length === 0) {
      return oldRow;
    }

    React.startTransition(() => {
      setChangedField(changedFields[0]);
      setRowToUpdate({
        newRow,
        oldRow,
        changedFields,
      });
      setConfirmOpen(true);
    });

    return newRow;
  };

  useEffect(() => {
    if (rowToUpdate) {
      setConfirmOpen(true);
    }
  }, [rowToUpdate]);

  return (
    <>
      {show1 && (
        <FiltroRolloutTelefonica
          filter={filter}
          setFilter={setFilter}
          toggle={toggle1}
          atualiza={listaFilterrollouttelefonica}
        />
      )}
      <ConfirmaModal
        open={confirmOpen}
        quantity={rowSelectionModel.length}
        onConfirm={handleConfirmSave}
        onCancel={handleCancelSave}
        campo={changedField}
      />
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
                    deletadoidpmts={idpmtdeletado}
                  />{' '}
                </>
              ) : null}
              {telacadastrot2edicao ? (
                <>
                  {' '}
                  <Telat2editar
                    show={telacadastrot2edicao}
                    setshow={settelacadastrot2edicao}
                    ididentificador={ididentificador}
                    atualiza={listarollouttelefonica}
                    pmuf={pmuf}
                    titulo={titulot2}
                    idr={idr}
                    idobra={idobra}
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
              ) : null}{' '}
              <ToastContainer
                position="top-right"
                autoClose={5000}
                hideProgressBar={false}
                newestOnTop={false}
                closeOnClick
                rtl={false}
                pauseOnFocusLoss
                draggable
                pauseOnHover
              />{' '}
              <ToastContainer />
              <div className="row g-3">
                <div className="col-sm-12">
                  Anexar Documentação em Massa
                  <div className="d-flex flex-row-reverse custom-file">
                    <InputGroup>
                      <Input
                        type="file"
                        onChange={handleChange}
                        className="custom-file-input"
                        id="customFile3"
                      />
                      <Button
                        color="primary"
                        onClick={handleFileUpload}
                        disabled={modoVisualizador()}
                      >
                        Anexar
                      </Button>
                    </InputGroup>
                  </div>
                </div>
                <div className="col-sm-3">
                  <Button color="link" onClick={gerarexcel}>
                    Exportar Excel
                  </Button>
                </div>
                <div className="col-sm-9">
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button color="primary" onClick={chamarfiltro}>
                      Aplicar Filtros
                    </Button>
                    {JSON.parse(localStorage.getItem('permission'))?.marcardesmarcarsiteavulso ===
                      1 && (
                      <div>
                        <Button color="primary" onClick={() => marcarComoAvulso()} className="me-2">
                          Marcar como Avulso
                        </Button>
                        <Button
                          color="primary"
                          onClick={() => desmarcarComoAvulso()}
                          className="me-2"
                        >
                          Desmarcar como Avulso
                        </Button>
                      </div>
                    )}
                    {JSON.parse(localStorage.getItem('permission'))
                      ?.adicionarsitemanualmentetelefonica === 1 && (
                      <Button
                        color="success"
                        onClick={() => setShowAdicionarSiteManual(true)}
                        className="me-2"
                      >
                        Adicionar SITE manualmente
                      </Button>
                    )}
                  </div>
                </div>
              </div>
              <br />
              <Box sx={{ height: '85%', width: '100%' }}>
                <DataGrid
                  apiRef={apiRef}
                  rows={totalacionamento}
                  getRowId={(row) => row.id}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  checkboxSelection
                  processRowUpdate={handleProcessRowUpdate}
                  onProcessRowUpdateError={handleProcessRowUpdateError}
                  rowSelectionModel={rowSelectionModel}
                  onRowSelectionModelChange={setRowSelectionModel}
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  getRowClassName={(parametros) =>
                    parametros.row.deletado === 1 ? 'linha-diferente' : ''
                  }
                  //isRowSelectable={(rowSelectable) => rowSelectable.row.deletado !== 1}
                  sx={{
                    '& .MuiDataGrid-row.Mui-selected': {
                      backgroundColor: '#32ccbc !important', // cor base
                      color: '#fff', // texto claro para contraste
                      transition: 'background-color 0.2s ease-in-out',
                      '&:hover': {
                        backgroundColor: '#28a89b !important', // cor um pouco mais escura no hover
                      },
                    },

                    '& .MuiDataGrid-cell:focus': {
                      outline: 'none', // remove a borda azul padrão
                    },
                    '& .MuiDataGrid-row.linha-diferente .MuiDataGrid-cell': {
                      backgroundColor: '#ffe0b2 !important',
                    },
                    '& .MuiDataGrid-row.linha-diferente .MuiDataGrid-cell:hover': {
                      backgroundColor: '#ffcc80 !important',
                    },

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
                    "& .MuiDataGrid-columnHeader[data-field='docplan']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='docvitoriareal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='req']": {
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
                    "& .MuiDataGrid-columnHeader[data-field='vistoriareal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='vistoriaplan']": {
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
                    "& .MuiDataGrid-columnHeader[data-field='inventariodesinstalacao']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='initialtunningreal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='initialtunningrealfinal']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='initialtunnigstatus']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='aprovacaossv']": {
                      backgroundColor: '#4caf50', // Verde
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='statusaprovacaossv']": {
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
                    "& .MuiDataGrid-columnHeader[data-field='acompanhamentofisicoobservacao']": {
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

                    "& .MuiDataGrid-columnHeader[data-field='infra']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessoatividade']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessocomentario']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessooutros']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessoformaacesso']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='ddd']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='latitude']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='longitude']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessoobs']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessosolicitacao']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessodatasolicitacao']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessodatainicial']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessodatafinal']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='acessostatus']": {
                      backgroundColor: '#9c27b0',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='origem']": {
                      backgroundColor: '#2196f3',
                      color: 'white',
                    },
                    "& .MuiDataGrid-columnHeader[data-field='avulso']": {
                      backgroundColor: '#2196f3',
                      color: 'white',
                    },
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                  paginationModel={paginationModel}
                  onPaginationModelChange={setPaginationModel}
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

      {/* Modal Adicionar Site Manual */}
      <AdicionarSiteManual
        show={showAdicionarSiteManual}
        setShow={setShowAdicionarSiteManual}
        onSiteAdded={listarollouttelefonica}
      />
    </>
  );
};
Rollouttelefonica.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Rollouttelefonica;
