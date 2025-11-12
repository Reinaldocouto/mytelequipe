import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Button, Input, Modal, ModalBody, ModalHeader, ModalFooter, InputGroup } from 'reactstrap';
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
import Pagination from '@mui/material/Pagination';
import { Box } from '@mui/material';
import LinearProgress from '@mui/material/LinearProgress';
import * as Icon from 'react-feather';
import DeleteIcon from '@mui/icons-material/Delete';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import Mensagemsimples from '../../Mensagemsimples';
import Mensagemescolha from '../../Mensagemescolha';
import exportExcel from '../../../data/exportexcel/Excelexport';
import modoVisualizador from '../../../services/modovisualizador';

const Extratofechamento = ({
  setshow,
  show,
  empresa,
  mespg,
  email,
  regional,
  numerol,
  status,
  datapagamento,
}) => {
  const [mensagem, setmensagem] = useState('');
  const [extrato, setextrato] = useState([]);
  const [mensagemmostrardel, setmensagemmostrardel] = useState('');
  const [extratototal, setextratototal] = useState('');
  const [desconto, setdesconto] = useState(0);
  const [extratototalcdesc, setextratototalcdesc] = useState(0);
  const [subvalor, setsubvalor] = useState(0);
  //    const [valorpago, setvalorpago] = useState('');
  const [loading, setloading] = useState(false);
  const [pageSize, setPageSize] = useState(12);
  const [emailadcional, setemailadcional] = useState('');
  const [emailpj, setemailpj] = useState('');
  const [mostra, setmostra] = useState('');
  const [motivo, setmotivo] = useState('');
  const [mensagemtela, setmensagemtela] = useState('');
  const [po, setpo] = useState('');
  const [deascricao, setdeascricao] = useState('');
  const [mespagamentol, setmespagamentol] = useState('');
  const [observacao, setobservacao] = useState('');
  const [observacaointerna, setobservacaointerna] = useState('');

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    empresalocal: empresa,
    mespagamento: mespg,
    numero: numerol,
    datapagamento,
    status,
  };
  console.log(datapagamento);
  const toggle = () => {
    setshow(!show);
  };

  
  const lista = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/extrato', { params }).then((response) => {
        setextrato(response.data);

        if (response.data.length !== 0) {
          setemailadcional(response.data[1].emailfechamento);
          console.log(response.data[1].emailfechamento);
          setobservacaointerna(response.data[1].observacaointerna);
        }
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const formatToTwoDecimalPlaces = (value) => {
    // Converte o valor para número (se já não for) e formata para duas casas decimais
    const formattedValue = parseFloat(value).toFixed(2);
    return formattedValue;
  };

  const descontar = (desc, valort) => {
    setdesconto(desc);
    setextratototalcdesc(formatToTwoDecimalPlaces(valort - desc));
  };

  const listadesconto = async (valort) => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/extratodesconto', { params }).then((response) => {
        console.log(response.data.desconto);
        if (response.data.desconto === undefined) {
          setdesconto('0');
          descontar(0, valort);
        } else {
          setdesconto(response.data.desconto);
          descontar(formatToTwoDecimalPlaces(response.data.desconto), valort);
        }
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listatotal = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/extratototal', { params }).then((response) => {
        setextratototal(response.data.total);
        setsubvalor(response.data.totalsimples);
        listadesconto(response.data.totalsimples);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function apagar(polocal, deascricaolocal, mespagamentolocal) {
    //correigir e colocar o numero pra não excluir coisa errada
    setmensagemmostrardel(true);
    setpo(polocal);
    setdeascricao(deascricaolocal);
    setmespagamentol(mespagamentolocal);
  }

  const apagarpagamento = () => {
    setmensagem('');
    api
      .post('v1/projetoericsson/fechamento/apagapagamento', {
        po,
        deascricao,
        mespagamentol,
        empresa,
      })
      .then((response) => {
        if (response.status === 201) {
          setmostra(true);
          setmotivo(1);
          setmensagemtela('Pagamento Excluido');
          lista();
          listatotal();
          listadesconto();
        } else {
          setmostra(true);
          setmotivo(2);
          setmensagemtela('Erro excluir pagamento!');
        }
      })
      .catch((err) => {
        console.log(err);
        if (err.response) {
          setmensagem(err.response);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  const salvardesconto = () => {
    setmensagem('');
    api
      .post('v1/projetoericsson/salvadesconto', {
        desconto,
        mespg,
        empresa,
        numerol,
      })
      .then((response) => {
        if (response.status === 201) {
          setmostra(true);
          setmotivo(1);
          setmensagemtela('Desconto Salvo');
          lista();
          listatotal();
          listadesconto();
        } else {
          setmostra(true);
          setmotivo(2);
          setmensagemtela('Erro ao Salvar desconto!');
        }
      })
      .catch((err) => {
        console.log(err);
        if (err.response) {
          setmensagem(err.response);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  function confirmacaodel(resposta) {
    setmensagemmostrardel(false);
    if (resposta === 1) {
      apagarpagamento();
    }
  }

  //tabela de itens
  const columns = [
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          disabled={modoVisualizador()}
          icon={<DeleteIcon />}
          label="Apagar"
          onClick={() =>
            apagar(parametros.row.po, parametros.row.descricao, parametros.row.mespagamento)
          }
        />,
      ],
    },
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
      field: 'status',
      headerName: 'Status',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datadopagamento',
      headerName: 'Data do Pagamento',
      width: 120,
      align: 'left',
      type: 'date',
      editable: false,
      valueGetter: (a) => {
        const { value } = a;
        return value ? new Date(value) : null;
      },
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
      width: 80,
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

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="secondary"
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

  const enviaremail = () => {
    setmensagem('');
    api
      .post('v1/email/acionamentopj/extrato', {
        destinatario: emailadcional,
        destinatario1: emailpj,
        assunto: `FECHAMENTO ERICSSON - ${params.status}`,
        mespg,
        empresa,
        regiona: regional,
        observacao,
        status: params.status,
        datapagamento: params.datapagamento,
        observacaointerna,
        numero: numerol,
        idusuario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 200) {
          setmostra(true);
          setmotivo(1);
          setmensagemtela('Email Enviando com Sucesso!');
        } else {
          setmostra(true);
          setmotivo(2);
          setmensagemtela('Erro ao enviar a mensagem!');
        }
      })
      .catch((err) => {
        console.log(err);
        if (err.response) {
          setmensagem(err.response);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  const gerarexcel = () => {
    const excelData = extrato.map((item) => {
      console.log(item);
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
    exportExcel({ excelData, fileName: 'extrato' });
  };

  const iniciatabelas = () => {
    setemailpj(email);
    lista();
    listatotal();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={toggle.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable"
    >
      <ModalHeader toggle={toggle.bind(null)}>Extrato de Pagamento</ModalHeader>
      <ModalBody>
        {mensagem.length > 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}
        {mostra ? (
          <>
            {' '}
            <Mensagemsimples
              show={mostra}
              setshow={setmostra}
              mensagem={mensagemtela}
              motivo={motivo}
              titulo="Enviar E-mail de Acionamento"
            />{' '}
          </>
        ) : null}
        {mensagemmostrardel && (
          <>
            {' '}
            <Mensagemescolha
              show={mensagemmostrardel}
              setshow={setmensagemmostrardel}
              titulotopo="Excluir"
              mensagem="Deseja realmente excluir esse pagamento?"
              respostapergunta={confirmacaodel}
            />{' '}
          </>
        )}
        {loading ? (
          <Loader />
        ) : (
          <>
            <Button color="link" onClick={() => gerarexcel()}>
              Exportar Excel
            </Button>
            <div className="row g-3">
              <div className="col-sm-6">
                Empresa
                <Input type="text" value={empresa} disabled />
              </div>
              <div className="col-sm-3">
                Data Pagamento
                <Input type="month" value={mespg} disabled />
              </div>
            </div>
            <br />
            <Box sx={{ height: 460, width: '100%' }}>
              <DataGrid
                rows={extrato}
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
              />
            </Box>

            <div className=" col-sm-12 d-flex flex-row-reverse">
              <div className="col-sm-2">
                Sub Total
                <Input type="text" value={extratototal} disabled />
              </div>
            </div>
            <div className=" col-sm-12 d-flex flex-row-reverse">
              <div className="col-sm-2">
                Desconto
                <InputGroup>
                  <Input
                    type="number"
                    onChange={(e) => descontar(e.target.value, subvalor)}
                    value={desconto}
                  />
                  <Button color="primary" onClick={salvardesconto} disabled={modoVisualizador()}>
                    <Icon.Check />{' '}
                  </Button>
                </InputGroup>
              </div>
            </div>
            <div className=" col-sm-12 d-flex flex-row-reverse">
              <div className="col-sm-2">
                Valor a Total
                <Input type="text" value={extratototalcdesc} disabled />
              </div>
            </div>
            <div className="col-sm-12">
              E-mails PJ
              <Input
                type="text"
                onChange={(e) => setemailpj(e.target.value)}
                value={emailpj}
                placeholder="Digite os e-mails separados por virgula"
              />
            </div>
            <br />
            <div className="col-sm-12">
              E-mails adicionais
              <Input
                type="text"
                onChange={(e) => setemailadcional(e.target.value)}
                value={emailadcional}
                placeholder="Digite os e-mails separados por virgula"
              />
            </div>
            <br />
            <div className="col-sm-12">
              Mensagem E-mail
              <Input
                type="textarea"
                onChange={(e) => setobservacao(e.target.value)}
                value={observacao}
                placeholder="Corpo do email"
              />
            </div>
            <br />
            <br />
          </>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="secondary" onClick={enviaremail}>
          Enviar E-mail <Icon.Mail />
        </Button>
        <Button color="secondary">
          Imprimir <Icon.Printer />
        </Button>
        <Button color="secondary" onClick={toggle.bind(null)}>
          Sair <Icon.LogOut />
        </Button>
      </ModalFooter>
    </Modal>
  );
};
Extratofechamento.propTypes = {
  mespg: PropTypes.string,
  empresa: PropTypes.string,
  setshow: PropTypes.func.isRequired,
  show: PropTypes.bool.isRequired,
  email: PropTypes.string,
  regional: PropTypes.string,
  numerol: PropTypes.string,
  status: PropTypes.string,
  datapagamento: PropTypes.string,
};

export default Extratofechamento;
