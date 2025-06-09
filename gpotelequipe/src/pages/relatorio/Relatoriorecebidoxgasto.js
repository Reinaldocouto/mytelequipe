import { useState, useEffect } from 'react';
import { Card, CardBody, CardTitle } from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  //GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  GridToolbarContainer,
  GridToolbarExport,
  ptBR,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';

export default function Relatoriorecebidoxgasto() {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [recebimentoxgastos, setrecebimentoxgastos] = useState([]);
  const [mensagem, setmensagem] = useState('');

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  function CustomToolbar() {
    return (
      <GridToolbarContainer>
        <GridToolbarExport />
      </GridToolbarContainer>
    );
  }

  const listarecebimentoxgastos = async () => {
    try {
      setLoading(true);
      await api.get('v1/recebidoxgasto', { params }).then((response) => {
        setrecebimentoxgastos(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  /*  function visualizar(polocal) {
    console.log(polocal)

}  */

  //tabela de itens
  const columns = [
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    /*    {
          field: 'actions',
          headerName: 'Ação',
          type: 'actions',
          width: 80,
          align: 'center',
          getActions: (parametros) => [
              <GridActionsCellItem
                //  icon={<DeleteIcon />}
                  label="Visualizar"
                  onClick={() => visualizar(parametros.row.po)}
              />,
          ],
      }, */
    {
      field: 'rfp',
      headerName: 'RFP',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'id',
      headerName: 'ID',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'site',
      headerName: 'Sigla',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'regiona',
      headerName: 'Regional',
      width: 160,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'situacaoimplantacao',
      headerName: 'Situação Implantação',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'situacaodaintegracao',
      headerName: 'Situação Integração',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'mosreal',
      headerName: 'Mos Real',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'instalreal',
      headerName: 'Install Real',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'integreal',
      headerName: 'Integração Real',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'valorpo',
      headerName: 'Valor POs',
      width: 200,
      align: 'right',
      type: 'numero',
      editable: false,
    },
    {
      field: 'valorfaturado',
      headerName: 'Valor Faturado',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'docinstalacao',
      headerName: 'doc instalacao',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'docinfra',
      headerName: 'doc infra',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'Statusfamentrega',
      headerName: 'Status FAM entrega',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'StatusfamInstalacao',
      headerName: 'Status FAM Instalacao',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'tipo',
      headerName: 'tipo',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'aceitacaofical',
      headerName: 'aceitacao',
      width: 200,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'PendenciasObra',
      headerName: 'Pendencias Obra',
      width: 300,
      align: 'right',
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

  const iniciatabelas = () => {
    listarecebimentoxgastos();
  };

  useEffect(() => iniciatabelas(), []);
  return (
    <div className="col-sm-12">
      {mensagem.length > 0 ? (
        <div className="alert alert-danger mt-2" role="alert">
          {mensagem}
        </div>
      ) : null}
      <Card>
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Relatório
          </CardTitle>
        </CardBody>
        <CardBody>
          {loading ? (
            <Loader />
          ) : (
            <>
              <Box sx={{ height: 550, width: '100%' }}>
                <DataGrid
                  rows={recebimentoxgastos}
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
                  slots={{
                    toolbar: CustomToolbar,
                  }}
                  //opções traduzidas da tabela
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                />
              </Box>
            </>
          )}
        </CardBody>
      </Card>
    </div>
  );
}
