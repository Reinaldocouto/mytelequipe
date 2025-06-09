import React, { useState, useEffect } from 'react';
import {
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  FormGroup,
  Input,
  Label,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  //GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridToolbarContainer,
  GridToolbarExport,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';

const Relacionamento = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [recebimentoxgastos, setrecebimentoxgastos] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [totalpo, settotalpo] = useState('');
  const [agfaturar, setagfaturar] = useState('');
  const [valorfaturado, setvalorfaturado] = useState('');

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





  
  //tabela de itens
  const columns = [
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'rfp',
      headerName: 'RFP',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'id',
      headerName: 'ID',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      width: 120,
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
      width: 130,
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
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'mosreal',
      headerName: 'Mos Real',
      width: 120,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'instalreal',
      headerName: 'Install Real',
      width: 120,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'integreal',
      headerName: 'Integração Real',
      width: 120,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'valorpo',
      headerName: 'Valor POs',
      width: 150,
      align: 'right',
      type: 'numero',
      editable: false,
    },
    {
      field: 'valorfaturado',
      headerName: 'Valor Faturado',
      width: 150,
      align: 'right',
      type: 'numero',
      editable: false,
    },
    {
      field: 'docinstalacao',
      headerName: 'Doc instalacao',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'docinfra',
      headerName: 'Doc Infra',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'Statusfamentrega',
      headerName: 'FAM entrega',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'StatusfamInstalacao',
      headerName: 'FAM Instalacao',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'tipo',
      headerName: 'Tipo',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'aceitacaofical',
      headerName: 'Aceitação',
      width: 130,
      align: 'center',
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

  const toggle = () => {
    setshow(!show);
  };

  const iniciatabelas = () => {
    listarecebimentoxgastos();
    listarecebimentoxgastossummary();
  };

  useEffect(() => iniciatabelas(), []);
  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle.bind(null)}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader>Relatorio PO x Faturado</ModalHeader>
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
              <div className="row g-3">
                <FormGroup check>
                  <Input type="checkbox" id="check7" />
                  <Label check> </Label>
                </FormGroup>
              </div>
              <Box sx={{ height: '82%', width: '100%' }}>
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
          <ModalBody>
            <div className="row g-3">
              <div className="col-sm-2">
                Total de PO
                <Input type="text" value={totalpo} placeholder="" disabled />
              </div>
              <div className="col-sm-2">
                Valor Faturado
                <Input type="text" value={valorfaturado} placeholder="" disabled />
              </div>
              <div className="col-sm-2">
                Aguardando Faturar
                <Input type="text" value={agfaturar} placeholder="" disabled />
              </div>
            </div>
          </ModalBody>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggle.bind(null)}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Relatoriopoxfaturado.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Relatoriopoxfaturado;
