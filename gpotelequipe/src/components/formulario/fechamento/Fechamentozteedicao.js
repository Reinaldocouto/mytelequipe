import { useState, useEffect } from 'react';
import './style.css';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, FormGroup, Input } from 'reactstrap';
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
import Mensagemescolha from '../../Mensagemescolha';
import exportExcel from '../../../data/exportexcel/Excelexport';
import Extratofechamentozte from './Extratofechamentozte';
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

const Fechamentozteedicao = ({ setshow, show, idempresa, empresa, email }) => {
  const [value, setValue] = useState(0);
  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [projeto, setprojeto] = useState([]);
  const [projetohistorico, setprojetohistorico] = useState([]);
  const [loading, setloading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [mensagem, setmensagem] = useState('');
  const [mensagemmostrar, setmensagemmostrar] = useState('');
  const [numerol, setnumerol] = useState('');
  const [geralfechamento, setgeralfechamento] = useState('');
  const [datapagamento, setdatapagamento] = useState('');
  const [porcpag, setporcpag] = useState('');
  const [valorserv, setvalorserv] = useState('');
  const [valorpago, setvalorpago] = useState('');
  const [observacao, setobservacao] = useState('');
  const [observacaointerna, setobservacaointerna] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [telaextrato, settelaextrato] = useState('');
  const [porcentagempg, setporcentagem] = useState('');
  const [valorTotalHistorico, setValorTotalHistorico] = useState();
  const [siteid, setsiteid] = useState();
  const [sitefrom, setsitefrom] = useState();
  const [linhasCorrespondentesPoItem, setlinhasCorrespondentesPoItem] = useState([]);

  const togglecadastro = () => {
    setshow(!show);
  };

  const params = {
    idgeralfechamento: geralfechamento,
    idempresalocal: idempresa,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    numero: numerol,
    fechamento: datapagamento,
    deletado: 0,
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  function Numerosemana() {
    const currentdate = new Date(datapagamento);
    const oneJan = new Date(currentdate.getFullYear(), 0, 1); // Primeiro dia do ano
    const ano = currentdate.getFullYear(); // Pegando o ano corretamente
    const numberOfDays = Math.floor((currentdate - oneJan) / (24 * 60 * 60 * 1000)); // Dias desde 1º de janeiro
    const result = Math.ceil((numberOfDays + oneJan.getDay() + 1) / 7); // Número da semana
    console.log(`${ano}/${result}`);
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
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetozte/fechamentoporempresa', { params }).then((response) => {
        setprojeto(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listahistorico = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/projetozte/historicopagamento', { params });
      const { data } = response;

      // Validar campos de data
      const validatedData = data.map((item) => {
        if (item.inicioatividadereal === '1899-12-30') {
          item.inicioatividadereal = '';
        }
        if (item.aprovacaocosmx === '1899-12-30') {
          item.aprovacaocosmx = '';
        }
        return item;
      });

      setprojetohistorico(validatedData);
      //      console.log("Historico: ", projetohistorico)

      // Filtrando poitems que correspondem ao datapagamento e numerol
      const encontraPoItem = validatedData
        .filter((item) => item.mespagamento === datapagamento && item.numero === numerol)
        .map((item) => item.poitem);

      setlinhasCorrespondentesPoItem(encontraPoItem);
      //      console.log("poitens relacionados: ", encontraPoItem)

      const totalValorPagamento = validatedData.reduce((acc, item) => {
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
    } catch (err) {
      setmensagem(err.message);
      console.log(err.message);
    } finally {
      setloading(false);
    }
  };

  /* useEffect(() => {
       if (datapagamento && numerol) {
         listahistorico();
       }
     }, [datapagamento, numerol]);
   
     useEffect(() => {
       lista();
     }, []);  */

  useEffect(() => {
    if (datapagamento) {
      Numerosemana();
    }
  }, [datapagamento]);

  const getRowClassName = (param) => {
    return linhasCorrespondentesPoItem.includes(param.row.poitem) ? 'highlighted-row' : '';
  };

  const selecao = (stat, siteidlocal, sitefromlocal, valorservico, porcentagem, observacaoint) => {
    setsiteid(siteidlocal);
    setsitefrom(sitefromlocal);
    setgeralfechamento(stat);
    setvalorserv(valorservico);
    setporcpag(100);
    setvalorpago(valorservico);
    setobservacao('');
    setobservacaointerna(observacaoint);
    setporcentagem(porcentagem);
  };

  //tabela de itens
  const historicopagamento = [
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'state',
      headerName: 'STATE',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'os',
      headerName: 'OS',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'siteid',
      headerName: 'ID SITE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'sitename',
      headerName: 'SITENAME(DE)',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'sitenamefrom',
      headerName: 'SITENAME(PARA)',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'ztecode',
      headerName: 'ZTECODE',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'servicedescription',
      headerName: 'SERVICE DESCRIPTION',
      width: 350,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'qty',
      headerName: 'QTY',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'statusdoc',
      headerName: 'STATUS DOC',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'docresp',
      headerName: 'RESPONSAVEL DOC',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'porcentagem',
      headerName: 'PORCENTAGEM',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'valorpago',
      headerName: 'VALOR PAGO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'fechamento',
      headerName: 'FECHAMENTO',
      width: 150,
      align: 'left',
      editable: false,
    },
  ];

  const columns = [
    // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
    {
      field: 'state',
      headerName: 'STATE',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'os',
      headerName: 'OS',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'siteid',
      headerName: 'ID SITE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'sitename',
      headerName: 'SITENAME(DE)',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'sitenamefrom',
      headerName: 'SITENAME(PARA)',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'ztecode',
      headerName: 'ZTECODE',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'servicedescription',
      headerName: 'SERVICE DESCRIPTION',
      width: 350,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'qty',
      headerName: 'QTY',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'statusdoc',
      headerName: 'STATUS DOC',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'docresp',
      headerName: 'RESPONSAVEL DOC',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'valorlpu',
      headerName: 'VALOR LPU',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'valorpj',
      headerName: 'VALOR PJ',
      width: 150,
      align: 'left',
      editable: false,
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
              parametros.row.siteid,
              parametros.row.sitenamefrom,
              parametros.row.valorpjsimples,
              parametros.row.porcentagem,
              parametros.row.Obs2,
            )
          }
        />,
      ],
    },
  ];

  function extratopagamento() {
    if (!datapagamento) {
      setmensagem('Informe o MES e ANO de pagamento');
      return;
    }
    settelaextrato(true);
  }

  function salvapagamento(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/projetozte/fechamento/salvapagamento', {
        dataenviofechamento: datapagamento,
        porcentagem: porcpag,
        fechamento: datapagamento,
        idfechamento: geralfechamento,
        valor: valorpago,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setobservacao('');
          setobservacaointerna('');
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
      .post('v1/projetozte/fechamento/salvapagamento', {
        dataenviofechamento: datapagamento,
        porcentagem: porcpag,
        fechamento: datapagamento,
        idfechamento: geralfechamento,
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
    setporcpag(valorporc);
    setvalorpago(vservico);
    /*   if (Number(ppg) + Number(valorporc) <= 100) {
             setmensagem('');
             setporcpag(valorporc);
             setvalorpago(vservico * (valorporc / 100));
           } else {
             setmensagem('Porcentagem maior que 100%');
           }*/
  };

  const iniciatabelas = () => {
    setnumerol(1);
    lista();
    listahistorico();
  };

  const gerarexcelpag = () => {
    if (projeto.length === 0) {
      setmensagem('Sem dados para exportar.');
      return;
    }
    setmensagem('');

    const excelData = projeto.map((item) => {
      return {
        'SITE ID': item.siteid,
        'SITE(PARA)': item.sitefromto,
        UF: item.uf,
        REGIAO: item.region,
        QTY: item.qty,
        'Inicio Atividade Real': item.inicioatividadereal,
        'APROVAÇÃO COSMX': item.aprovacaocosmx,
        'VALOR LPU': item.valorlpu,
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
        'SITE ID': item.siteid,
        'SITE(PARA)': item.sitefromto,
        UF: item.uf,
        REGIAO: item.region,
        QTY: item.qty,
        'Inicio Atividade Real': item.inicioatividadereal,
        'APROVAÇÃO COSMX': item.aprovacaocosmx,
        'VALOR LPU': item.valorlpu,
        FECHAMENTO: item.fechamento,
        OBSERVACAO: item.obs2,
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
        Fechamento ZTE
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
              <div className="col-sm-3">
                Empresa
                <Input type="text" value={empresa} disabled />
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

              <div className="col-sm-2">
                <br />
                <Button color="primary" onClick={() => listahistorico()}>
                  Pesquisar
                </Button>
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
                        localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                        getRowClassName={getRowClassName} // Use a função getRowClassName
                      />
                    </Box>
                  </div>

                  <div className="col-sm-3">
                    <div className="row g-3">
                      <div className="col-sm-12">
                        SITE ID
                        <Input type="text" value={siteid} placeholder="Site id" disabled />
                      </div>
                      <div className="col-sm-12">
                        SITE(PARA)
                        <Input type="text" value={sitefrom} placeholder="SITE(PARA)" disabled />
                      </div>
                    </div>
                    <br />
                    <div className="row g-3">
                      <div className="col-sm-6">
                        Valor
                        <Input
                          type="number"
                          onChange={(e) => setvalorpago(e.target.value)}
                          value={valorpago}
                          placeholder="Valor do Pagamento"
                          disabled
                        />
                      </div>
                      <div className="col-sm-6">
                        <Input
                          type="hidden"
                          onChange={(e) => calculaporc(e.target.value, valorserv, porcentagempg)}
                          value={porcpag}
                          placeholder="Porc. do Pagamento"
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
                      <div className="col-sm-12">
                        Observação Interna
                        <Input
                          type="textarea"
                          onChange={(e) => setobservacaointerna(e.target.value)}
                          value={observacaointerna}
                          placeholder="Observacao Interna"
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
                            Salvar Pagamento
                          </Button>
                        </div>
                      </div>
                    </div>
                    <br />
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
            <Extratofechamentozte
              show={telaextrato}
              setshow={settelaextrato}
              empresa={empresa}
              mespg={datapagamento}
              email={email}
              idempresalocal={idempresa}
            />{' '}
          </>
        )}
        {/*value === 0 && valorPGAberto && (
          <Button color="">
            Total: {valorPGAberto.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
          </Button>
        )*/}
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

Fechamentozteedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  idempresa: PropTypes.number,
  atualiza: PropTypes.node,
  idsite: PropTypes.string,
  email: PropTypes.string,
  empresa: PropTypes.string,
};

export default Fechamentozteedicao;
