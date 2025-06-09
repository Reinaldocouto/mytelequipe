import { useState, useEffect } from 'react';
import {
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  FormGroup,
  Input,
  InputGroup,
} from 'reactstrap';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import * as Icon from 'react-feather';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';
//import SearchIcon from '@mui/icons-material/Search';
import Typography from '@mui/material/Typography';
import EditIcon from '@mui/icons-material/Edit';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Extratofechamento from './Extratofechamento';
import Mensagemescolha from '../../Mensagemescolha';
import exportExcel from '../../../data/exportexcel/Excelexport';
import modoVisualizador from '../../../services/modovisualizador';

function TabPanel(props) {
  const { children, value, value1, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
  value1: PropTypes.number.isRequired,
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

const Fechamentoericssonedicao = ({ setshow, show, empresa, email, regional }) => {
  const [value, setValue] = useState(0);
  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [projeto, setprojeto] = useState([]);
  const [projetohistorico, setprojetohistorico] = useState([]);
  const [projetopagamento, setprojetopagamento] = useState([]);
  const [loading, setloading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [mensagem, setmensagem] = useState('');
  const [mensagemmostrar, setmensagemmostrar] = useState('');
  const [numerol, setnumerol] = useState('');
  const [codigoservicosel, setcodigoservicosel] = useState('');
  const [servicosel, setservicosel] = useState('');
  const [geralfechamento, setgeralfechamento] = useState('');
  const [datapagamento, setdatapagamento] = useState('');
  const [porcpag, setporcpag] = useState('');
  const [valorserv, setvalorserv] = useState('');
  const [valorpago, setvalorpago] = useState('');
  const [observacao, setobservacao] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [telaextrato, settelaextrato] = useState('');
  const [datainicio, setdatainicio] = useState('');
  const [datafim, setdatafim] = useState('');
  const [sigla, setsigla] = useState('');
  const [porcentagempg, setporcentagem] = useState('');
  const [valorTotalHistorico, setValorTotalHistorico] = useState();
  const [valorPGAberto, setValorPGAberto] = useState();

  const togglecadastro = () => {
    setshow(!show);
  };

  const params = {
    busca: empresa,
    idgeralfechamento: geralfechamento,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    datainicioop: datainicio,
    datafimop: datafim,
    numero: numerol,
    sig: sigla,
    deletado: 0,
  };

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
        onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
      />
    );
  }
  const extractNumericValue = (valueString) => {
    const numericString = valueString.replace(/[^\d,-]/g, ''); // Remove tudo exceto dígitos, vírgulas e sinais de menos
    return parseFloat(numericString.replace(',', '.')); // Substitui ',' por '.' e converte para número
  };

  const lista = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/fechamentoporempresa', { params }).then((response) => {
        const { data } = response;
        setprojeto(data);
        const totalValorPagamento = data.reduce((acc, item) => {
          if (item.valorpagamento) {
            const valorNumerico = extractNumericValue(item.valorpagamento);
            return acc + valorNumerico;
          }
          return acc;
        }, 0);
        const totalFormatado = totalValorPagamento.toLocaleString('pt-BR', {
          style: 'currency',
          currency: 'BRL',
        });
        setValorPGAberto(totalFormatado);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
      console.log(err.message);
    } finally {
      setloading(false);
    }
  };

  const listahistorico = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/historicopagamento', { params }).then((response) => {
        setprojetohistorico(response.data);
        const { data } = response;

        // Calculando o total usando reduce
        const totalValorPagamento = data.reduce((acc, item) => {
          if (item.valorpagamento) {
            const valorNumerico = extractNumericValue(item.valorpagamento);
            return acc + valorNumerico;
          }
          return acc;
        }, 0);
        const totalFormatado = totalValorPagamento.toLocaleString('pt-BR', {
          style: 'currency',
          currency: 'BRL',
        });
        setValorTotalHistorico(totalFormatado);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
      console.log(err.message);
    } finally {
      setloading(false);
    }
  };

  const listapagamento = async () => {
    try {
      const response = await api.get('v1/projetoericsson/listapagamento', { params });
      const { data } = response;
      setprojetopagamento(data);
      setmensagem('');
    } catch (err) {
      // Capturando e definindo a mensagem de erro no estado
      setmensagem(err.message);
    } finally {
      // Qualquer limpeza de estado ou indicador de carregamento pode ser feita aqui
      // setloading(false);
    }
  };

  const selecao = (stat, codigo, servico, valorservico, porcentagem) => {
    listapagamento();
    setcodigoservicosel(codigo);
    setservicosel(servico);
    setgeralfechamento(stat);
    setvalorserv(valorservico);
    setvalorpago(0);
    setobservacao('');
    setporcentagem(porcentagem);
    try {
      //  setloading(true);
      api
        .get('v1/projetoericsson/listapagamento', { params: { idgeralfechamento: stat } })
        .then((response) => {
          setprojetopagamento(response.data);
          setmensagem('');
        });
    } catch (err) {
      console.log(err);
      setmensagem(err.message);
    } finally {
      // setloading(false);
    }
  };

  //tabela de itens
  const historicopagamento = [
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'po',
      headerName: 'PO',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'poitem',
      headerName: 'PO ITEM',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'sigla',
      headerName: 'Sigla',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'idsydle',
      headerName: 'ID Sydle',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'estado',
      headerName: 'Estado',
      width: 80,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'codigo',
      headerName: 'Código',
      width: 160,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricao',
      heyaderName: 'Descrição',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'mespagamento',
      headerName: 'Mês de Pagamento',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'porcentagem',
      headerName: 'Porcentagem',
      width: 100,
      align: 'right',
      type: 'numero',
      editable: false,
    },
    {
      field: 'valorpagamento',
      headerName: 'Valor Pagamento',
      width: 150,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'observacao',
      headerName: 'Observacao',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
  ];

  const columns = [
    {
      field: 'poitem',
      headerName: 'PO ITEM',
      width: 130,
      align: 'left',
      editable: false,
    },
    {
      field: 'sigla',
      headerName: 'sigla',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'idsydle',
      headerName: 'IDSydle',
      width: 80,
      align: 'left',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'estado',
      headerName: 'Estado',
      width: 70,
      align: 'left',
      editable: false,
    },
    {
      field: 'codigo',
      headerName: 'Codigo',
      width: 170,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descricao',
      width: 350,
      align: 'left',
      editable: false,
    },
    {
      field: 'mosreal',
      headerName: 'MOS REAL',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'instalreal',
      headerName: 'INSTALL REAL',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'integreal',
      headerName: 'INTEGR. REAL',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'statusdoc',
      headerName: 'DOC INSTALAÇÃO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'documentacaosituacao',
      headerName: 'DOC INFRA',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'respfamentrega',
      headerName: 'FAM ENTREGA',
      width: 150,
      align: 'left',
      editable: false,
    },

    {
      field: 'respfaminstalacao',
      headerName: 'FAM INSTALAÇÃO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'valorpj',
      headerName: 'Valor PJ',
      width: 180,
      type: 'currency',
      align: 'left',
      editable: false,
    },
    {
      field: 'quant',
      headerName: 'Quant',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'porcentagem',
      headerName: 'Porc. Total Pago',
      width: 180,
      align: 'left',
      editable: true,
    },

    {
      field: 'valorpagamento',
      headerName: 'Valor Total Pago',
      width: 180,
      align: 'left',
      editable: true,
    },
    {
      field: 'observacao',
      headerName: 'Observação',
      width: 450,
      align: 'left',
      editable: true,
    },
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 120,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Selecao"
          onClick={() =>
            selecao(
              parametros.id,
              parametros.row.po,
              parametros.row.descricao,
              parametros.row.valorpj,
              parametros.row.porcentagem,
            )
          }
        />,
      ],
    },
  ];

  const columnspagamento = [
    {
      field: 'mespagamento',
      headerName: 'Mês Pagamento',
      width: 180,
      align: 'left',
      editable: true,
    },
    {
      field: 'porcentagem',
      headerName: 'Porcentagem',
      width: 180,
      align: 'left',
      editable: true,
    },

    {
      field: 'valorpagamento',
      headerName: 'Valor Pago',
      width: 180,
      align: 'left',
      editable: true,
    },
    {
      field: 'observacao',
      headerName: 'obs',
      width: 350,
      align: 'left',
      editable: true,
    },
  ];

  function extratopagamento() {
    if (!datapagamento) {
      setmensagem('Informe o mês de pagamento');
      return;
    }
    settelaextrato(true);
  }

  function salvapagamento(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/projetoericsson/fechamento/salvapagamento', {
        mespagamento: datapagamento,
        porcentagem: porcpag,
        observacao,
        servicosel,
        codigoservicosel,
        geralfechamento,
        repostaalteracao: 0,
        numerol,
        empresa,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setcodigoservicosel('');
          setservicosel('');
          setobservacao('');
          setvalorpago(0);
          setporcpag(0);

          lista();
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
          if (err.response.data.erro === 'Já existe pagamento nesse periodo') {
            setmensagemmostrar(true);
          }
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  function salvapagamentoalterar() {
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/projetoericsson/fechamento/salvapagamento', {
        mespagamento: datapagamento,
        porcentagem: porcpag,
        observacao,
        servicosel,
        codigoservicosel,
        geralfechamento,
        repostaalteracao: 1,
        empresa,
        numerol,        
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          lista();
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  function confirmacao(resposta) {
    setmensagemmostrar(false);
    if (resposta === 1) {
      salvapagamentoalterar();
    }
  }

  const calculaporc = (valorporc, vservico, ppg) => {
    console.log(ppg + valorporc);
    if (Number(ppg) + Number(valorporc) <= 100) {
      setmensagem('');
      setporcpag(valorporc);
      setvalorpago(vservico * (valorporc / 100));
    } else {
      setmensagem('Porcentagem maior que 100%');
    }
  };

  const pesquisa = () => {
    lista();
    listapagamento();
    listahistorico();
  };

  const iniciatabelas = () => {
    setnumerol(1);
  };

  const gerarexcelpag = () => {
    if (projeto.length === 0) {
      setmensagem('Sem dados para exportar.');
      return;
    }
    setmensagem('');

    const excelData = projeto.map((item) => {
      return {
        PO: item.po,
        POITEM: item.poitem,
        Sigla: item.sigla,
        IDSydle: item.idsydle,
        Cliente: item.cliente,
        Estado: item.estado,
        Codigo: item.codigo,
        Descricao: item.descricao,
        Mespagamento: item.mespagamento,
        Porcentagem: item.porcentagem,
        Valorpagamento: item.valorpagamento,
        Observacao: item.observacao,
      };
    });
    exportExcel({ excelData, fileName: 'Fechamento_aguardando_pagamento' });
  };

  const gerarexcelhist = () => {
    if (projetohistorico.length === 0) {
      setmensagem('Sem dados para exportar.');
      return;
    }
    setmensagem('');
    const excelData = projetohistorico.map((item) => {
      return {
        PO: item.po,
        POITEM: item.poitem,
        Sigla: item.sigla,
        IDSydle: item.idsydle,
        Cliente: item.cliente,
        Estado: item.estado,
        Codigo: item.codigo,
        Descricao: item.descricao,
        Mespagamento: item.mespagamento,
        Porcentagem: item.porcentagem,
        Valorpagamento: item.valorpagamento,
        Observacao: item.observacao,
      };
    });
    exportExcel({ excelData, fileName: 'fechamento_historico' });
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        Fechamento
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        {mensagem.length !== 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}
        {mensagemsucesso.length > 0 ? (
          <div className="alert alert-success" role="alert">
            {' '}
            Registro Salvo
          </div>
        ) : null}
        {mensagemmostrar && (
          <>
            {' '}
            <Mensagemescolha
              show={mensagemmostrar}
              setshow={setmensagemmostrar}
              titulotopo="Alteração"
              mensagem="Já existe pagamento nesse site com esse periodo, deseja alterar o pagamento feito?"
              respostapergunta={confirmacao}
            />{' '}
          </>
        )}
        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-sm-2">
                Período Inicial
                <Input
                  type="date"
                  onChange={(e) => setdatainicio(e.target.value)}
                  value={datainicio}
                  placeholder="Periodo Inicial"
                />
              </div>
              <div className="col-sm-2">
                Período Final
                <Input
                  type="date"
                  onChange={(e) => setdatafim(e.target.value)}
                  value={datafim}
                  placeholder="Periodo Final"
                />
              </div>

              <div className="col-sm-3">
                Empresa
                <Input type="text" value={empresa} disabled />
              </div>

              <div className="col-sm-2">
                Sigla/IDSydle
                <InputGroup>
                  <Input type="text" onChange={(e) => setsigla(e.target.value)} value={sigla} />
                  <Button color="primary" position="" onClick={pesquisa}>
                    <Icon.Filter />{' '}
                  </Button>
                </InputGroup>
              </div>

              <div className="col-sm-2">
                Data Pagamento
                <Input
                  type="month"
                  onChange={(e) => setdatapagamento(e.target.value)}
                  value={datapagamento}
                  placeholder="cliente nome"
                />
              </div>
              <div className="col-sm-1">
                Nº
                <Input type="select" onChange={(e) => setnumerol(e.target.value)} value={numerol}>
                  <option value="1">1</option>
                  <option value="2">2</option>
                  <option value="3">3</option>
                  <option value="4">4</option>
                </Input>
              </div>
            </div>
            <br />

            <Box sx={{ width: '100%' }}>
              <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                <Tabs value={value} onChange={handleChange} aria-label="basic tabs">
                  <Tab label="Pagamentos em Aberto" {...a11yProps(0)} />
                  <Tab label="Históricos" {...a11yProps(1)} />
                </Tabs>
              </Box>

              {/** Pagamentos em Aberto */}
              <TabPanel value={value} index={0}>
                {/**gerar excel*/}
                <Button color="link" onClick={() => gerarexcelpag()}>
                  Exportar Excel
                </Button>
                <div className="row g-3">
                  <div className="col-sm-9">
                    Acionamentos
                    <Box sx={{ height: 'calc(100vh - 340px)', width: '100%' }}>
                      <DataGrid
                        rows={projeto}
                        columns={columns}
                        loading={loading}
                        pageSize={pageSize}
                        onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                        disableSelectionOnClick
                        experimentalFeatures={{ newEditingApi: true }}
                        components={{
                          Pagination: CustomPagination,
                          LoadingOverlay: LinearProgress,
                          NoRowsOverlay: CustomNoRowsOverlay,
                        }}
                        //opções traduzidas da tabela
                        localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                      />
                    </Box>
                  </div>

                  <div className="col-sm-3">
                    <div className="row g-3">
                      <div className="col-sm-12">
                        PO
                        <Input
                          type="text"
                          value={codigoservicosel}
                          placeholder="Codigo do Serviço"
                          disabled
                        />
                      </div>
                      <div className="col-sm-12">
                        Descrição
                        <Input
                          type="text"
                          value={servicosel}
                          placeholder="Descrição do serviço"
                          disabled
                        />
                      </div>
                    </div>
                    <br />
                    <div className="row g-3">
                      <div className="col-sm-6">
                        Porcentagem
                        <Input
                          type="number"
                          onChange={(e) => calculaporc(e.target.value, valorserv, porcentagempg)}
                          value={porcpag}
                          placeholder="Porc. do Pagamento"
                        />
                      </div>
                      <div className="col-sm-6">
                        Valor
                        <Input
                          type="number"
                          onChange={(e) => setvalorpago(e.target.value)}
                          value={valorpago}
                          placeholder="Valor do Pagamento"
                        />
                      </div>
                      <br />
                      <div className="col-sm-12">
                        Observação
                        <Input
                          type="textarea"
                          onChange={(e) => setobservacao(e.target.value)}
                          value={observacao}
                          placeholder="Observacao"
                        />
                      </div>
                    </div>
                    <br />
                    <div className="row g-3">
                      <div className="col-sm-12">
                        <div className="d-flex flex-row-reverse custom-file">
                          <Button
                            color="success"
                            onClick={salvapagamento}
                            disabled={modoVisualizador()}
                          >
                            Salvar Pagamento{' '}
                          </Button>
                        </div>
                      </div>
                    </div>
                    <br />
                    <Box sx={{ height: 300, width: '100%' }}>
                      <DataGrid
                        rows={projetopagamento}
                        columns={columnspagamento}
                        loading={loading}
                        pageSize={pageSize}
                        onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                        disableSelectionOnClick
                        experimentalFeatures={{ newEditingApi: true }}
                        components={{
                          Pagination: CustomPagination,
                          LoadingOverlay: LinearProgress,
                          NoRowsOverlay: CustomNoRowsOverlay,
                        }}
                        //opções traduzidas da tabela
                        localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                      />
                    </Box>
                  </div>
                </div>

                <hr />
              </TabPanel>

              {/** Históricos */}
              <TabPanel value={value} index={1}>
                {/**gerar excel*/}
                <Button color="link" onClick={() => gerarexcelhist()}>
                  Exportar Excel
                </Button>
                <div className="row g-3">
                  <div className="col-sm-12">
                    Histórico de Pagamento
                    <Box sx={{ height: 'calc(100vh - 340px)', width: '100%' }}>
                      <DataGrid
                        rows={projetohistorico}
                        columns={historicopagamento}
                        loading={loading}
                        pageSize={pageSize}
                        onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                        disableSelectionOnClick
                        experimentalFeatures={{ newEditingApi: true }}
                        components={{
                          Pagination: CustomPagination,
                          LoadingOverlay: LinearProgress,
                          NoRowsOverlay: CustomNoRowsOverlay,
                        }}
                        //opções traduzidas da tabela
                        localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                      />
                    </Box>
                  </div>
                </div>
              </TabPanel>
            </Box>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        {telaextrato && (
          <>
            {' '}
            <Extratofechamento
              show={telaextrato}
              setshow={settelaextrato}
              empresa={empresa}
              mespg={datapagamento}
              email={email}
              regional={regional}
              numerol={numerol}
            />{' '}
          </>
        )}
        {value === 0 && valorPGAberto && (
          <Button color="">
            Total: {valorPGAberto.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
          </Button>
        )}
        {value === 1 && valorTotalHistorico && (
          <Button color="">
            Total:{' '}
            {valorTotalHistorico.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
          </Button>
        )}
        <Button color="primary" onClick={extratopagamento}>
          Gerar Extrato de Pagamento <Icon.BookOpen />
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair <Icon.LogOut />
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Fechamentoericssonedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  empresa: PropTypes.string,
  email: PropTypes.string,
  regional: PropTypes.string,
};

export default Fechamentoericssonedicao;
