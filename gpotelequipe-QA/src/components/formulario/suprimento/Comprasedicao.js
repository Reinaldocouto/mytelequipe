import { useState, useEffect } from 'react';
import {
  Button,
  FormGroup,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
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
} from '@mui/x-data-grid';
import { Box } from '@mui/material';
import Select from 'react-select';
import PropTypes from 'prop-types';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
//import InfoIcon from '@mui/icons-material/Info';
import LinearProgress from '@mui/material/LinearProgress';
//import AddIcon from '@mui/icons-material/Add';
import * as Icon from 'react-feather';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Comprasedicaoitens from './Comprasedicaoitens';
import Fornecedoredicao from '../cadastro/Fornecedoredicao';
import Mensagemescolha from '../../Mensagemescolha';
import Mensagemsimples from '../../Mensagemsimples';
import './textarea.css'; // Importe o arquivo CSS para estilização
import Excluirregistro from '../../Excluirregistro';
import modoVisualizador from '../../../services/modovisualizador';
//import Parcelas from '../parcelamento/Parcela';

const Comprasedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemmostrar, setmensagemmostrar] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [fornecedorlista, setfornecedorlista] = useState([]);
  const [idfornecedor, setidfornecedor] = useState('');
  //  const [tipofretelista, settipofretelista] = useState([]);
  const [ordemcompraitenslista, setordemcompraitenslista] = useState([]);
  const [idordemcompra, setidordemcompra] = useState('');
  const [pageSize, setPageSize] = useState(5);
  const [telaprodutoitens, settelaprodutoitens] = useState('');
  //  const [verparcelas, setverparcelas] = useState(false);
  const [telaprodutoitensedicao, settelaprodutoitensedicao] = useState('');
  const [titulo, settitulo] = useState('');
  const [titulomensagem, settitulomensagem] = useState('');
  const [mensagemdados, setmensagemdados] = useState('');
  const [telamensagem, settelamensagem] = useState('');
  const [idordemcompraitemlocal, setidordemcompraitemlocal] = useState('');
  const [nitens, setnitens] = useState(0);
  const [somaqtdes, setsomaqtdes] = useState(0);
  const [totalprodutos, settotalprodutos] = useState(0);
  const [desconto, setdesconto] = useState(0);
  const [frete, setfrete] = useState(0);
  const [totalipi, settotalipi] = useState(0);
  const [totalicmsst, settotalicmsst] = useState(0);
  const [totalgeral, settotalgeral] = useState(0);
  const [dataprevista, setdataprevista] = useState('');
  const [numerofornecedor, setnumerofornecedor] = useState(0);
  const [datacompra, setdatacompra] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  // const [condicaopagamento, setcondicaopagamento] = useState('');
  const [idtransportadora, setidtransportadora] = useState('');
  const [idtipofrete, setidtipofrete] = useState('');
  const [observacao, setobservacao] = useState('');
  const [observacaointerna, setobservacaointerna] = useState('');
  const [selectedOptionfornecedor, setSelectedOptionfornecedor] = useState(null);
  // const [selectedOptiontransportadora, setSelectedOptiontransportadora] = useState(null);
//  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telacadastroedicanovo, settelacadastroedicanovo] = useState('');
  //const [idpessoa, setidpessoa] = useState('');
  //   const [relacionamentopessoalista, setrelacionamentopessoalista] = useState([]);
  // const [desabilita, setdesabilita] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idordemcomprabusca: ididentificador,
    idpessoabusca: idfornecedor,
    idpedido: ididentificador,
    idordemcompra: ididentificador,
    origem: 'PEDIDOCOMPRA',
    deletado: 0,
  };

  //Funções
  const listafornecedor = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpjforn', { params }).then((response) => {
        console.log('teste: ', response.data);
        setfornecedorlista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

/*  const listapessoas = async () => {
    try {
      await api.get('/v1/pessoaid', { params }).then((response) => {
        setSelectedOptionfornecedor({ value: response.data.idpessoa, label: response.data.nome });
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      console.log();
    }
  }; */

  /*   const listatipofrete = async () => {
        try {
            setloading(true);
            await api.get('v1/tipofrete', { params })
                .then(response => {
                    settipofretelista(response.data);
                    setmensagem('');
                })
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    } */

  const formatToTwoDecimalPlaces = (value) => {
    // Converte o valor para número (se já não for) e formata para duas casas decimais
    const formattedValue = parseFloat(value).toFixed(2);
    return formattedValue;
  };

  const somacampos = (xfrete, xdesconto) => {
    setfrete(xfrete);
    setdesconto(xdesconto);
    settotalgeral(
      formatToTwoDecimalPlaces(
        Number(totalprodutos) +
          Number(totalipi) +
          Number(totalicmsst) +
          Number(xfrete) -
          Number(xdesconto),
      ),
    );
  };

  const listaordemcompraitenssoma = async () => {
    try {
      setloading(true);
      await api.get('v1/ordemcompra/itens/soma', { params }).then((response) => {
        setnitens(response.data.nitens);
        setsomaqtdes(response.data.totalquantidade);
        settotalprodutos(formatToTwoDecimalPlaces(response.data.totalvalorproduto));
        settotalipi(formatToTwoDecimalPlaces(response.data.totalipi));
        settotalicmsst(formatToTwoDecimalPlaces(response.data.totalicmsst));
        settotalgeral(
          formatToTwoDecimalPlaces(
            Number(response.data.totalvalorproduto) +
              Number(response.data.totalipi) +
              Number(response.data.totalicmsst) +
              Number(frete) -
              Number(desconto),
          ),
        );
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaordemcompraitens = async () => {
    try {
      setloading(true);
      await api.get('v1/ordemcompra/itens', { params }).then((response) => {
        setordemcompraitenslista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };
 /* function listaselectetela() {
    listafornecedor();
    listapessoas();
    listaordemcompraitens();
  } */
  const atualizaitens = () => {
    setidordemcompra(ididentificador);
    listaordemcompraitens();
    listaordemcompraitenssoma();
  };

  const novocadastro = () => {
    api
      .post('v1/ordemcompra/novocadastroitens', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setidordemcompraitemlocal(response.data.retorno);
          settitulo('Novo Item');
          settelaprodutoitens(true);
        } else {
          setmensagem(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

 /* const novofornecedor = () => {
    api
      .post('v1/pessoa/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          //setidfornecedor(response.data.retorno)
          setidpessoa(response.data.retorno);
          settitulo('Novo Fornecedor');
          settelacadastroedicanovo(true);
        } else {
          setmensagem(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };  */

 /* function editarfornecedor() {
    if (idfornecedor !== null && idfornecedor !== 0 && idfornecedor !== '') {
      settitulo('Editar Pessoas');
      settelacadastroedicao(true);
    } else {
      settelamensagem(true);
      setmensagemdados('Não é possivel mostrar os dados porque falta selecionar o Fornecedor');
      settitulomensagem('Dados do Fornecedor');
    }
  }  */
 
  /* const funcverparcela = () => {
        setverparcelas(true);
    }  */

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/ordemcompra', {
        idordemcompra: ididentificador,
        idfornecedor,
        nitens,
        somaqtdes,
        totalprodutos,
        desconto,
        frete,
        totalipi,
        totalicmsst,
        totalgeral,
        idtransportadora,
        numerofornecedor,
        datacompra,
        dataprevista,
        observacao,
        idtipofrete,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setshow(!show);
          togglecadastro.bind(null);
          atualiza();
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

  function limpacampos() {
    setnitens('0');
    setsomaqtdes('0.00');
    settotalprodutos('0.00');
    setdesconto('0.00');
    setfrete('0.00');
    settotalipi('0.00');
    settotalicmsst('0.00');
    settotalgeral('0.00');
  }

  const listaordemcompra = async () => {
    try {
      setloading(true);
      await api.get('v1/ordemcompraid', { params }).then((response) => {
        if (Object.keys(response.data).length === 0) {
          limpacampos();
        } else {
          setidordemcompra(response.data.idordemcompra);
          setidfornecedor(response.data.idfornecedor);
          setnitens(response.data.nitens);
          setsomaqtdes(response.data.somaqtdes);
          settotalprodutos(formatToTwoDecimalPlaces(response.data.totalprodutos));
          settotalipi(formatToTwoDecimalPlaces(response.data.totalipi));
          settotalicmsst(formatToTwoDecimalPlaces(response.data.totalicmsst));
          settotalgeral(formatToTwoDecimalPlaces(response.data.totalgeral));
          setnumerofornecedor(response.data.numerofornecedor);
          setdatacompra(response.data.data);
          setdataprevista(response.data.dataprevisto);
          setidtransportadora(response.data.idtransportadora);
          if (response.data.frete !== 'undefined') {
            setfrete(formatToTwoDecimalPlaces(response.data.frete));
          } else {
            setfrete(0.0);
          }
          setdesconto(formatToTwoDecimalPlaces(response.data.desconto));
          setobservacao(response.data.observacoes);
          setobservacaointerna(response.data.observacoesinterna);
          setidtipofrete(response.data.idtipofrete);

          // Função para usar o setValue - (para alimentar o select)
          setSelectedOptionfornecedor({
            value: response.data.idfornecedor,
            label: response.data.nomefornecedor,
          }); // Criar  logica de olhar na configuração se vai usar nome razão social ou nome fantasia
          // setSelectedOptiontransportadora({ value: response.data.idtransportadora, label: response.data.nometransportadora }); // Criar  logica de olhar na configuração se vai usar nome razão social ou nome fantasia}
        }
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function deleteUser(stat) {
    settelaexclusao(true);
    setidordemcompraitemlocal(stat);
    listaordemcompraitens();
  }

  function alterarItens(stat) {
    settelaprodutoitensedicao(true);
    listaordemcompraitens();
    setidordemcompraitemlocal(stat);
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

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado.</div>
      </GridOverlay>
    );
  }

  //tabela de itens
  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 120,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          title="Alterar"
          onClick={() => alterarItens(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          title="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'produto',
      headerName: 'Produto',
      width: 320,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'codigosku',
      headerName: 'Cod(SKU)',
      width: 130,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'quantidade',
      headerName: 'Qtde',
      width: 120,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'unidade',
      headerName: 'Unid',
      width: 120,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'preco',
      headerName: 'Preço un',
      width: 140,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'ipi',
      headerName: 'IPI%',
      width: 100,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'valortotal',
      headerName: 'Preço Total',
      width: 150,
      align: 'right',
      type: 'number',
      editable: false,
    },
  ];

  const handleKeyUpFornecedor = (event) => {
    if (event.key === 'Enter') {
      console.log(event);
    }
  };

  const handleChangefornecedor = (stat) => {
    if (stat !== null) {
      setidfornecedor(stat.value);
      setSelectedOptionfornecedor({ value: stat.value, label: stat.label });
    } else {
      setidfornecedor(0);
      setSelectedOptionfornecedor({ value: null, label: null });
    }
  };

  /*  const handleChangetransportadora = (stat) => {
        if (stat !== null) {
            setidtransportadora(stat.value);
            setSelectedOptiontransportadora({ value: stat.value, label: stat.label });
        } else {
            setidtransportadora(0);
            setSelectedOptiontransportadora({ value: null, label: null });
        }
    } */

  function confirmacao(resposta) {
    //  setmensagemmostrar(true);
    if (resposta === 1) {
      //  setverparcelas(false);
      // setcondicaopagamento('');
      // setdesabilita(false);
      settitulomensagem('Sucesso');
      setmensagemdados('Sucesso');
      settelamensagem(true);
    }
  }

  /*  const editarcondicaopagamento = () => {
        setmensagemmostrar(true);
    }  */

  const iniciatabelas = () => {
    setidordemcompra(ididentificador);
    limpacampos();
    listafornecedor();
    listaordemcompra();
    listaordemcompraitens();
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
      className="modal-dialog modal-xl modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        Cadastro Ordem de Compra
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        {mensagem.length > 0 ? (
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
        {telamensagem && (
          <>
            {' '}
            <Mensagemsimples
              show={telamensagem}
              setshow={settelamensagem}
              mensagem={mensagemdados}
              titulo={titulomensagem}
            />{' '}
          </>
        )}
        {mensagemmostrar && (
          <>
            {' '}
            <Mensagemescolha
              show={mensagemmostrar}
              setshow={setmensagemmostrar}
              titulotopo="Confirmação"
              mensagem="O Parcelamento anterior será apagado. Deseja realmente editar o parcelamento? "
              respostapergunta={confirmacao}
            />{' '}
          </>
        )}
        {telaexclusao ? (
          <>
            <Excluirregistro
              show={telaexclusao}
              setshow={settelaexclusao}
              ididentificador={idordemcompraitemlocal}
              quemchamou="COMPRASITENS"
              atualiza={atualizaitens}
              idlojaatual={localStorage.getItem('sessionloja')}
            />{' '}
          </>
        ) : null}

        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-2">
                Nº
                <Input
                  type="text"
                  value={idordemcompra}
                  style={{ backgroundColor: 'white' }}
                  placeholder=""
                  disabled
                />
              </div>
              <div className="col-sm-10">
                Fornecedor
                <InputGroup className="comprimento-group">
                  <Input
                    type="hidden"
                    onChange={(e) => setidfornecedor(e.target.value)}
                    value={idfornecedor}
                    name="idfornecedor"
                  />
                  {/** 
                                    <Input type="hidden" onChange={(e) => setstatus(e.target.value)} value={status} name="status" />
                                    <Input type="hidden" onChange={(e) => setidpacienteconvenio(e.target.value)} value={idpacienteconvenio} name="idpacienteconvenio" />
                                    */}
                  <Select
                    className="comprimento-maior"
                    isClearable
                    //components={{ Control: ControlComponent }}
                    isSearchable
                    name="fornecedor"
                    options={fornecedorlista}
                    placeholder="Selecione"
                    isLoading={loading}
                    onChange={handleChangefornecedor}
                    onKeyDown={handleKeyUpFornecedor}
                    value={selectedOptionfornecedor}
                    // ref={inputRef1}
                  />
                  {/* <Input type="text" onChange={(e) => setpaciente(e.target.value)} value={paciente} name="paciente" /> */}
                {/*  <Button
                    color="primary"
                    onClick={editarfornecedor}
                    title="Editar Fornecedor"
                     className="comprimento-menor"
                  >
                    <i className="bi bi-pencil-square"></i>
                  </Button>
                  <Button
                    color="primary"
                    onClick={novofornecedor}
                    title="Cadastrar Novo Fornecedor"
                    className="comprimento-menor"
                  >
                    {' '}
                    <AddIcon />
                  </Button>  */}
                  {/**  {telacadastroedicao && <> <Pessoasedicao show={telacadastroedicao} setshow={settelacadastroedicao} ididentificador={idfornecedor} titulotopo={titulo} atualiza={idfornecedor}  /> </>} */}
                  {telacadastroedicanovo && (
                    <>
                      {' '}
                      <Fornecedoredicao
                        show={telacadastroedicanovo}
                        setshow={settelacadastroedicanovo}
                       // ididentificador={idpessoa}
                        titulotopo={titulo}
                       // atualiza={idpessoa}
                      />{' '}
                    </>
                  )}
                </InputGroup>
              </div>
            </div>
            <div className="row g-3">
              <div className="col-sm-12">
                <Button color="link" onClick={listaordemcompraitens}>
                  Atualiza Itens
                </Button>
              {/*  <Button color="link" onClick={editarfornecedor}> 
                  dados do fornecedor
                </Button>
                {telacadastroedicao && (
                  <>
                    {' '}
                    <Fornecedoredicao
                      show={telacadastroedicao}
                      setshow={settelacadastroedicao}
                      ididentificador={idfornecedor}
                      titulotopo={titulo}
                      atualiza={listaselectetela}
                    />{' '}
                  </>
                )}
                <Button color="link">ver últimas compras</Button> */}
              </div>
            </div>
            <hr />
            <div className="row g-3">
              <div className="col-sm-4 d-md-flex align-items-center gap-2 ">
                <b>Itens da Compra</b>
              </div>
              <div className="col-sm-8 d-md-flex align-items-center gap-2 d-flex flex-row-reverse">
                <Button color="link" onClick={novocadastro} disabled={modoVisualizador()}>
                  {' '}
                  <Icon.PlusCircle /> Adicionar Item{' '}
                </Button>
              </div>
            </div>
            {telaprodutoitens ? (
              <>
                {' '}
                <Comprasedicaoitens
                  show={telaprodutoitens}
                  setshow={settelaprodutoitens}
                  ididentificador={idordemcompraitemlocal}
                  idordemcompralocal={ididentificador}
                  atualiza={atualizaitens}
                  titulotopo={titulo}
                />{' '}
              </>
            ) : null}
            {telaprodutoitensedicao ? (
              <>
                {' '}
                <Comprasedicaoitens
                  show={telaprodutoitensedicao}
                  setshow={settelaprodutoitensedicao}
                  ididentificador={idordemcompraitemlocal}
                  idordemcompralocal={ididentificador}
                  atualiza={atualizaitens}
                  titulotopo="Alterar Item"
                />{' '}
              </>
            ) : null}
            <Box sx={{ height: 400, width: '100%' }}>
              <DataGrid
                rows={ordemcompraitenslista}
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
                localeText={{
                  // Column menu text
                  columnMenuShowColumns: 'Mostra Colunas',
                  columnMenuManageColumns: 'Gerencia Colunas',
                  columnMenuFilter: 'Filtro',
                  columnMenuHideColumn: 'Esconder',
                  columnMenuUnsort: 'Desordenar',
                  columnMenuSortAsc: 'Classificar por Crescente',
                  columnMenuSortDesc: 'Classificar por Decrescente',
                }}
              />
            </Box>
            <hr />
            <p>
              <b>Totais da compra</b>
            </p>
            <div className="row g-3">
              <div className="col-sm-3">
                Nº de Itens
                <Input
                  type="number"
                  onChange={(e) => setnitens(e.target.value)}
                  value={nitens}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-3">
                Soma qtdes
                <Input
                  type="number"
                  onChange={(e) => setsomaqtdes(e.target.value)}
                  value={somaqtdes}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-3">
                Produtos
                <Input
                  type="number"
                  onChange={(e) => settotalprodutos(e.target.value)}
                  value={totalprodutos}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-3">
                Desconto
                <Input
                  type="number"
                  onChange={(e) => somacampos(frete, e.target.value)}
                  value={desconto}
                  placeholder=""
                />
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <div className="col-sm-3">
                Frete
                <Input
                  type="number"
                  onChange={(e) => somacampos(e.target.value, desconto)}
                  value={frete}
                  placeholder=""
                />
              </div>
              <div className="col-sm-3">
                Total do IPI
                <Input
                  type="number"
                  onChange={(e) => settotalipi(e.target.value)}
                  value={totalipi}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-3">
                ICMS ST
                <Input
                  type="number"
                  onChange={(e) => settotalicmsst(e.target.value)}
                  value={totalicmsst}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-3">
                Total geral
                <Input
                  type="number"
                  onChange={(e) => settotalgeral(e.target.value)}
                  value={totalgeral}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
            </div>
            <hr />
            <p>
              <b>Detalhes da Compra</b>
            </p>
            <div className="row g-3">
              <div className="col-sm-4">
                Nº Fornecedor
                <Input
                  type="text"
                  onChange={(e) => setnumerofornecedor(e.target.value)}
                  value={numerofornecedor}
                  placeholder=""
                />
              </div>
              <div className="col-sm-4">
                Data Compra
                <Input
                  type="date"
                  onChange={(e) => setdatacompra(e.target.value)}
                  value={datacompra}
                  placeholder=""
                />
              </div>
              <div className="col-sm-4">
                Data Prevista
                <Input
                  type="date"
                  onChange={(e) => setdataprevista(e.target.value)}
                  value={dataprevista}
                  placeholder=""
                />
              </div>
            </div>
            {/*    <hr />
                        <p><b>Pagamento</b></p>
                        <div className="row g-3">
                        <div className="col-sm-6">
                                Categoria
                                <Input type="select" name="UF">
                                    <option>Selecione</option>
                                </Input>
                            </div>
                            <div className="col-sm-10">
                                Condição de Pagamento   <Button color="link" onClick={editarcondicaopagamento} >Editar </Button>
                                <InputGroup>
                                    <Input type="text" onChange={(e) => setcondicaopagamento(e.target.value)} value={condicaopagamento} placeholder="Número de parcelas ou prazos. Exemplos: 30 60 ou 15,45,60" disabled={desabilita}  />
                                    <Button color="primary" onClick={funcverparcela} disabled={desabilita} > Gerar Parcelas</Button>
                                </InputGroup>
                            </div>
                            <div className="col-sm-12">
                                {verparcelas && <> <Parcelas valortotal={totalgeral} parcelamento={condicaopagamento} origem='PEDIDOCOMPRA' setshow={setverparcelas} show={verparcelas} ididentificador={idordemcompra} comando={setdesabilita  }/> </>}
                            </div>

                        </div>
                        <hr />
                        <p><b>Transporte</b></p>
                        <div className="row g-3">
                            <div className="col-sm-8">
                                Transportadora
                                <Select
                                    isClearable
                                    //components={{ Control: ControlComponent }}
                                    isSearchable
                                    name="transportadora"
                                    options={fornecedorlista}
                                    onChange={handleChangetransportadora}
                                    value={selectedOptiontransportadora}
                                    placeholder='Selecione'
                                    isLoading={loading}
                                />
                            </div>
                            <div className="col-sm-4">
                                Frete por Conta
                                <Input type="select" onChange={(e) => setidtipofrete(e.target.value)} value={idtipofrete} name="tipofrete">
                                    <option >Selecione</option>
                                    {
                                        tipofretelista.map(c => {
                                            return <option key={c.idtipofrete} value={c.idtipofrete}>{c.descricao}</option>
                                        })
                                    }
                                </Input>
                            </div>
                        </div>
                                <hr /> */}
            <div className="row g-3">
              <div className="col-sm-12">
                <b>Observações</b>
                <Input
                  type="textarea"
                  onChange={(e) => setobservacao(e.target.value)}
                  value={observacao}
                  placeholder=""
                />
              </div>
              <div className="col-sm-12">
                <b>Observações Internas</b>
                <Input
                  type="textarea"
                  onChange={(e) => setobservacaointerna(e.target.value)}
                  value={observacaointerna}
                  placeholder=""
                />
              </div>
            </div>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Comprasedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
};

export default Comprasedicao;
