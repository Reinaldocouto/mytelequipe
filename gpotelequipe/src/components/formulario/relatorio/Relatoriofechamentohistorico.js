import React, { useState, useEffect } from 'react';
import {
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Relatoriofechamentohistorico = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [totalacionamento, settotalacionamento] = useState([]);
  const [mensagem, setmensagem] = useState('');

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listaacionamentos = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/projetotelefonica/historicofechamento', { params });
      settotalacionamento(response.data);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

    const columns = [
            {
      field: 'nome',
      headerName: 'COLABORADOR',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'idpmts',
      headerName: 'IDMPTS',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'regional',
      headerName: 'REGIONAL',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmosigla',
      headerName: 'PMOSIGLA',
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
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'quantidade',
      headerName: 'QUANT.',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'codigolpuvivo',
      headerName: 'CODIGO LPU VIVO',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'tarefas',
      headerName: 'TAREFAS',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'valor',
      headerName: 'VALOR PJ',
      width: 150,
      align: 'right',
      type: 'number', // Melhor usar 'number' para valores monetários
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) return ''; // Caso o valor seja nulo
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
      },
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },

    {
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'nome',
      headerName: 'COLABORADOR',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    /*  {
        field: 'entregarequest',
        headerName: 'ENTREGA REQUEST',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
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
        headerName: 'ENTREGA PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      }, */

    {
      field: 'vistoriareal',
      headerName: 'VISTORIA REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },

    {
      field: 'entregareal',
      headerName: 'ENTREGA REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*  {
        field: 'fiminstalacaoplan',
        headerName: 'FIM INSTALACAO PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      }, */
    {
      field: 'fiminstalacaoreal',
      headerName: 'FIM INSTALACAO REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*   {
         field: 'integracaoplan',
         headerName: 'INTEGRACAO PLAN',
         width: 150,
         align: 'center',
         type: 'date', // Use 'date' para o DataGrid entender o tipo
         editable: false,
         valueFormatter: (parametros) => {
           if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
   
           const date = new Date(parametros.value);
           // Verifica se a data é 30/12/1899
           if (
             date.getDate() === 30 &&
             date.getMonth() === 11 && // Dezembro (0-based)
             date.getFullYear() === 1899
           ) {
             return '';
           }
   
           return date.toLocaleDateString('pt-BR');
         },
       },  */
    {
      field: 'integracaoreal',
      headerName: 'INTEGRACAO REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'ativacao',
      headerName: 'ATIVACAO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'documentacao',
      headerName: 'DOCUMENTACAO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*  {
        field: 'dtplan',
        headerName: 'DT PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      },  */
    {
      field: 'initialtunningreal',
      headerName: 'INITIAL TUNNING',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
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
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'statusobra',
      headerName: 'STATUS OBRA',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'mespagamento',
      headerName: 'MES PAGAMENTO',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },    
    {
      field: 'datapagamento',
      headerName: 'DATA PAGAMENTO',
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'valorpagamento',
      headerName: 'VALOR PAGO',
      width: 150,
      align: 'right',
      type: 'number', // Melhor usar 'number' para valores monetários
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) return ''; // Caso o valor seja nulo
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
      },
    },
    {
      field: 'porcentagem',
      headerName: '% PAGO',
      width: 80,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) {
          return '0%';
        }
        return `${(parametros.value * 100).toFixed(2)}%`;
      },
    },
    {
      field: 'tipopagamento',
      headerName: 'TIPO PAGAENTO',
      width: 180,
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
        const rowCount = apiRef.current.getRowsCount(); // Obtém total de itens
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
                    onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
                />
            </Box>
        );
    }

  const toggle = () => {
    setshow(!show);
  };

  const iniciatabelas = () => {
    listaacionamentos();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

    const gerarexcel = () => {
        const excelData = totalacionamento.map((item) => {
            const formatarData = (data) => {
                if (!data) return '';
                const d = new Date(data);
                if (
                    d.getFullYear() === 1899 &&
                    d.getMonth() === 11 &&
                    d.getDate() === 30
                ) {
                    return '';
                }
                return d.toLocaleDateString('pt-BR');
            };
    
            return {
            COLABORADOR: item.nome,    
            IDMPTS: item.idpmts,
            REGIONAL: item.regional,
            PO: item.po,
            PMOSIGLA: item.pmosigla,
            UFSIGLA: item.ufsigla,
            ATIVIDADE: item.atividade,
            QUANTIDADE: item.quantidade,
            'CODIGO LPU VIVO': item.codigolpuvivo,
            TAREFAS: item.tarefas,
            VALOR:  item.valor?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }),
            'DATA ACIONAMENTO': formatarData(item.dataacionamento),
            'DATA ENVIO EMAIL': formatarData(item.dataenvioemail),
            'VISTORIA REAL': formatarData(item.vistoriareal),
            'ENTREGA REAL': formatarData(item.entregareal),
            'FIM INSTALACAO REAL': formatarData(item.fiminstalacaoreal),
            'INTEGRACAO REAL': formatarData(item.integracaoreal),
            ATIVACAO: formatarData(item.ativacao),
            DOCUMENTACAO: formatarData(item.documentacao),
            'INITIAL TUNNING REAL': formatarData(item.initialtunningreal),
            'DT REAL': formatarData(item.dtreal),
            'STATUS OBRA': item.statusobra,
            'MES PAGAMENTO': item.mespagamento,
            'DATA PAGAMENTO': formatarData(item.datapagamento),
            'VALOR PAGO': item.valorpagamento?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }),
            '% PAGO': item.porcentagem ? `${(item.porcentagem * 100).toFixed(2)}%` : '0%', 
            'TIPO PAGAENTO': item.tipopagamento,
        };
    });

    exportExcel({ excelData, fileName: 'Relatório - Historico Fechamento' });
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
        <ModalHeader>Relatório - Histórico de Fechamentos</ModalHeader>
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
              <Button color="link" onClick={gerarexcel}>
                Exportar Excel
              </Button>

              <Box sx={{ height: '95%', width: '100%' }}>
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

Relatoriofechamentohistorico.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Relatoriofechamentohistorico;
