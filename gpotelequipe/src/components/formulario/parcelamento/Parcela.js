import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import { Box } from '@mui/material';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import LinearProgress from '@mui/material/LinearProgress';
import api from '../../../services/api';
import Parcelaedicao from './Parcelaedicao';
import modoVisualizador from '../../../services/modovisualizador';

const Parcelas = ({
  valortotal,
  parcelamento,
  origem,
  ididentificador,
  comando,
  setshow,
  show,
}) => {
  const [mensagem, setmensagem] = useState('');
  const [parcelalista, setparcelalista] = useState([]);
  const [loading, setloading] = useState(false);
  const [pageSize, setPageSize] = useState(12);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [mostrargrid, setmostrargrid] = useState('');

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idpedido: ididentificador,
    origem,
    deletado: 0,
  };

  const listaparcelas = async () => {
    try {
      setloading(true);
      await api.get('v1/parcelamento', { params }).then((response) => {
        if (response.status === 200) {
          setparcelalista(response.data);
          comando(true);
          setmostrargrid('mostrar');
        } else {
          setmostrargrid('');
          comando(false);
          setshow(!show);
        }
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function criarparcelamento() {
    console.log('cheguei no parcelamento');
    api
      .post('v1/parcelamento', {
        ididentificador,
        valortotal,
        origem,
        parcelamento,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');

          listaparcelas();
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
  }

  function alterarItens(stat) {
    console.log(stat);
    settelacadastroedicao(true);
  }
  function deleteUser(stat) {
    console.log(stat);
  }

  //tabela de itens
  const columns = [
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
      field: 'id',
      headerName: 'Parcela',
      width: 100,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'dias',
      headerName: 'Dias',
      width: 100,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'vencimento',
      headerName: 'Vencimento',
      width: 140,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'valor',
      headerName: 'Valor',
      width: 100,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'idformapagamento',
      headerName: 'Forma de Pagamento',
      width: 200,
      align: 'right',
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

  const iniciatabelas = () => {
    if (parcelamento === '') listaparcelas();
    else criarparcelamento();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <div>
      {mensagem.length > 0 ? (
        <div className="alert alert-danger mt-2" role="alert">
          {mensagem}
        </div>
      ) : null}
      {mostrargrid.length > 0 && (
        <>
          <Box sx={{ height: 300, width: '100%', textAlign: 'right' }}>
            <DataGrid
              rows={parcelalista}
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
        </>
      )}
      {telacadastroedicao && (
        <>
          {' '}
          <Parcelaedicao
            show={telacadastroedicao}
            setshow={settelacadastroedicao}
            ididentificador={ididentificador}
            atualiza={() => listaparcelas()}
          />{' '}
        </>
      )}
    </div>
  );
};
Parcelas.propTypes = {
  valortotal: PropTypes.number,
  parcelamento: PropTypes.string,
  origem: PropTypes.string,
  ididentificador: PropTypes.number,
  comando: PropTypes.func.isRequired,
  setshow: PropTypes.func.isRequired,
  show: PropTypes.bool.isRequired,
};

export default Parcelas;
