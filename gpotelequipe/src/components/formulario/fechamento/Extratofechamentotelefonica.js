import { useState, useEffect, useMemo, useCallback } from 'react';
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
  useGridApiRef,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import { Box } from '@mui/material';
import Typography from '@mui/material/Typography';
import LinearProgress from '@mui/material/LinearProgress';
import * as Icon from 'react-feather';
import DeleteIcon from '@mui/icons-material/Delete';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import Mensagemsimples from '../../Mensagemsimples';
import Mensagemescolha from '../../Mensagemescolha';
import exportExcel from '../../../data/exportexcel/Excelexport';
import modoVisualizador from '../../../services/modovisualizador';

const Extratofechamentotelefonica = ({
  setshow,
  show,
  empresa,
  mespg,
  email,
  regional,
  idempresalocal,
  tipopagamento,
  datapagamento,
}) => {
  const [idpagamento, setidpagamento] = useState('');
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
  const [mespagamentol, setmespagamentol] = useState('');
  const [observacao, setobservacao] = useState('');
  const [observacaointerna, setobservacaointerna] = useState('');
  const apiRef = useGridApiRef();
  const [columnVisibilityModel, setColumnVisibilityModel] = useState({});

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    empresalocal: empresa,
    mespagamento: mespg,
    idempresa: idempresalocal,
    uf: regional,
    tipopagamento,
    datapagamento,
  };

  const toggle = () => {
    setshow(!show);
  };

  const lista = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonicaid/extrato', { params }).then((response) => {
        const dados = Array.isArray(response.data) ? response.data : [];
        setextrato(dados);
        const primeiroRegistro = dados.length > 0 ? dados[0] : null;
        setemailpj(primeiroRegistro?.email ?? email ?? '');
        setobservacaointerna('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const emailadicional = async () => {
    try {
      console.log('emailadicional', params);
      const response = await api.get('v1/projetotelefonica/emailadicional', { params });
      setemailadcional(response.data?.emailextrato ?? '');
    } catch (err) {
      console.error(err.message);
      setemailadcional('');
    }
  };

  const formatToTwoDecimalPlaces = (value) => {
    // Converte o valor para número (se já não for) e formata para duas casas decimais
    const formattedValue = parseFloat(value).toFixed(2);
    return formattedValue;
  };

  const descontar = (desc, valort) => {
    setdesconto(desc);
    setextratototalcdesc(
      (valort - desc).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }),
    );
  };

  const listadesconto = async (valort) => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/extratodesconto', { params }).then((response) => {
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

  const apagar = useCallback((idacionamentovivo, mespagamento, idPagamento) => {
    setmensagemmostrardel(true);
    setpo(idacionamentovivo);
    setmespagamentol(mespagamento);
    setidpagamento(idPagamento);
  }, []);

  const apagarpagamento = () => {
    setmensagem('');
    api
      .post('v1/projetotelefonica/fechamento/apagapagamento', {
        po,
        mespagamentol,
        id: idpagamento,
      })
      .then((response) => {
        if (response.status === 201) {
          setmostra(true);
          setmotivo(1);
          setmensagemtela('Pagamento Excluido');
          lista();
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
      .post('v1/projetotelefonica/salvadesconto', {
        desconto,
        mespg,
        tpagamento: tipopagamento,
        dpagamento: datapagamento,
        idempresalocal,
      })
      .then((response) => {
        if (response.status === 201) {
          setmostra(true);
          setmotivo(1);
          setmensagemtela('Desconto Salvo');
          lista();
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
  const columns = useMemo(
    () => [
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
              apagar(parametros.id, parametros.row.mespagamento, parametros.row.idpagamento)
            }
          />,
        ],
      },
      {
        field: 'idpmts',
        headerName: 'IDPMTS',
        width: 120,
        align: 'left',
        type: 'string',
        editable: false,
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
        field: 'ufsigla',
        headerName: 'UFSIGLA',
        width: 120,
        align: 'left',
        type: 'string',
        editable: false,
      },
      {
        field: 'pmosigla',
        headerName: 'SIGLA',
        width: 100,
        align: 'left',
        type: 'string',
        editable: false,
      },
      {
        field: 'pmoregional',
        headerName: 'REGIONAL',
        width: 100,
        align: 'left',
        type: 'string',
        editable: false,
      },
      {
        field: 'brevedescricao',
        headerName: 'ESCOPO',
        width: 350,
        align: 'left',
        type: 'string',
        editable: false,
        renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
      },
      {
        field: 'quantidade',
        headerName: 'QUANT',
        width: 80,
        align: 'center',
        type: 'number',
        editable: false,
      },
      {
        field: 'codigolpuvivo',
        headerName: 'CODIGOLPUVIVO',
        width: 200,
        align: 'left',
        type: 'string',
        editable: false,
      },
      {
        field: 'valor',
        headerName: 'VALOR',
        width: 140,
        align: 'right',
        type: 'string',
        editable: false,
        valueFormatter: (parametros) => {
          if (parametros.value == null) return '';
          return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        },
      },
      {
        field: 'mespagamento',
        headerName: 'MÊS PAGAMENTO',
        width: 140,
        align: 'center',
        type: 'string',
        editable: false,
      },
      {
        field: 'porcentagem',
        headerName: '%',
        width: 100,
        align: 'left',
        type: 'numero',
        editable: false,
        valueFormatter: (parametros) => {
          if (parametros.value == null) {
            return '0%';
          }
return `${(parametros.value * 100).toFixed(2)}%`;
        },
      },
{
        field: 'valorpagamento',
        headerName: 'VALOR PAGAMENTO',
        width: 150,
        align: 'right',
        type: 'string',
        editable: false,
        valueFormatter: (parametros) => {
          if (parametros.value == null) return '';
          return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        },
      },
{
        field: 'entregareal',
        headerName: 'ENTREGA REAL',
        width: 150,
        align: 'center',
        type: 'date',
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return '';

          const date = new Date(parametros.value);
          if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
            return '';
          }

          return date.toLocaleDateString('pt-BR');
        },
      },
{
        field: 'fiminstalacaoreal',
        headerName: 'INSTALAÇÃO REAL',
        width: 150,
        align: 'center',
        type: 'date',
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return '';

          const date = new Date(parametros.value);
          if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
            return '';
          }

         return date.toLocaleDateString('pt-BR');
        },
      },
{
        field: 'datadopagamento',
        headerName: 'DATA DO PAGAMENTO',
        width: 150,
        align: 'left',
        type: 'string',
        editable: false,
      },
      {
        field: 'status',
        headerName: 'STATUS',
        width: 120,
        align: 'left',
        type: 'string',
        editable: false,
      },
      {
        field: 'integracaoreal',
        headerName: 'INTEGRAÇÃO REAL',
        width: 150,
        align: 'center',
        type: 'date',
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return '';

          const date = new Date(parametros.value);
          if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
            return '';
          }

        return date.toLocaleDateString('pt-BR');
        },
      },
{
        field: 'ativacao',
        headerName: 'ATIVAÇÃO',
        width: 150,
        align: 'center',
        type: 'date',
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return '';

          const date = new Date(parametros.value);
          if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
            return '';
          }

        return date.toLocaleDateString('pt-BR');
        },
      },
{
        field: 'documentacao',
        headerName: 'DOCUMENTAÇÃO',
        width: 150,
        align: 'center',
        type: 'date',
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return '';

          const date = new Date(parametros.value);
          if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
            return '';
          }

    return date.toLocaleDateString('pt-BR');
        },
      },
      {
        field: 'dtreal',
        headerName: 'DT REAL',
        width: 150,
        align: 'center',
        type: 'date',
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return '';

          const date = new Date(parametros.value);
          if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
            return '';
          }

        return date.toLocaleDateString('pt-BR');
        },
      },
{
        field: 'observacao',
        headerName: 'OBSERVAÇÃO',
        width: 200,
        align: 'left',
        type: 'string',
        editable: false,
        renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
      },
    ],
    [apagar],
  );

    const columnLookup = useMemo(() => {
    const lookup = {};
    columns.forEach((column) => {
      lookup[column.field] = column;
    });
    return lookup;
  }, [columns]);

  const getFormattedValue = useCallback(
    (column, row) => {
      if (!column || column.field === 'actions') {
        return '';
      }

      let value = row?.[column.field];

      if (column.valueGetter) {
        try {
          value = column.valueGetter({
            id: row?.id,
            field: column.field,
            value,
            row,
            api: apiRef.current,
            colDef: column,
          });
        } catch (error) {
          // mantém o valor original caso ocorra algum erro
        }
      }


      if (column.valueFormatter) {
        try {
          const formatted = column.valueFormatter({
            id: row?.id,
            field: column.field,
            value,
            api: apiRef.current,
            row,
            colDef: column,
          });

          if (formatted !== undefined) {
            return formatted;
          }
        } catch (error) {
          // caso ocorra erro no formatter, retorna o valor bruto
        }
      }

       if (value === null || value === undefined) {
        return '';
      }

    if (value instanceof Date) {
        return value.toLocaleDateString('pt-BR');
      }

        return value;
    },
[apiRef],
  );

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
      .post('v1/email/acionamentopj/extratotelefonica', {
        destinatario: emailadcional,
        destinatario1: emailpj,
        assunto: `FECHAMENTO TELEFONICA - ${tipopagamento}`,
        mespg,
        idempresalocal,
        empresa,
        regiona: regional,
        observacao,
        observacaointerna,
        idusuario: localStorage.getItem('sessionId'),
        tipopagamento: params.tipopagamento,
        datapagamento: params.datapagamento,
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
     setmensagem('');

    if (!extrato || extrato.length === 0) {
      setmensagem('Sem dados para exportar.');
      return;
    }

    const columnState = apiRef.current?.state?.columns;
    const orderedFields =
      columnState?.orderedFields && columnState.orderedFields.length > 0
        ? columnState.orderedFields
        : columns.map((column) => column.field);

    const visibilityModel = columnState?.visibilityModel ?? columnVisibilityModel;

    const visibleColumns = orderedFields
      .map((field) => columnLookup[field])
      .filter((column) => {
        if (!column) {
          return false;
        }
        const isVisible = visibilityModel?.[column.field];
        return isVisible === undefined || isVisible !== false;
      });

    if (visibleColumns.length === 0) {
      setmensagem('Nenhuma coluna visível para exportar.');
      return;
    }

    const excelData = extrato.map((row) => {
      const linha = {};
      visibleColumns.forEach((column) => {
        const header = column.headerName || column.field.toUpperCase();
        linha[header] = getFormattedValue(column, row);
      });
      return linha;
    });

    exportExcel({ excelData, fileName: 'extrato' });
  };

  const iniciatabelas = () => {
    setemailpj(email ?? '');
    lista();
    emailadicional();
    //listatotal();
  };

  useEffect(() => {
    const total = extrato.reduce((soma, row) => {
      return soma + (Number(row.valor) || 0);
    }, 0);
    setextratototal(total.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }));
    setsubvalor(total);
    listadesconto(total);
  }, [extrato]);

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
      <ModalHeader toggle={toggle.bind(null)} style={{ backgroundColor: 'white' }}>
        Extrato de Pagamento
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
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
                apiRef={apiRef}
                rows={extrato}
                columns={columns}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                experimentalFeatures={{ newEditingApi: true }}
                columnVisibilityModel={columnVisibilityModel}
                onColumnVisibilityModelChange={(newModel) => setColumnVisibilityModel(newModel)}
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
      <ModalFooter style={{ backgroundColor: 'white' }}>
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
Extratofechamentotelefonica.propTypes = {
  mespg: PropTypes.string,
  empresa: PropTypes.string,
  setshow: PropTypes.func.isRequired,
  show: PropTypes.bool.isRequired,
  email: PropTypes.string,
  regional: PropTypes.string,
  idempresalocal: PropTypes.string,
  tipopagamento: PropTypes.string,
  datapagamento: PropTypes.string,
};

export default Extratofechamentotelefonica;
