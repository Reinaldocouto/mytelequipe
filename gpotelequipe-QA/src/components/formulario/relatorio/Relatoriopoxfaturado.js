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
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Relatoriopoxfaturado = ({ setshow, show }) => {
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

  const listarecebimentoxgastos = async () => {
    try {
      setLoading(true);
      await api.get('v1/recebidoxgasto', { params }).then((response) => {
        setrecebimentoxgastos(response.data);
        setmensagem('');
        console.log("dados tabela",response.data)
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  const listarecebimentoxgastossummary = async () => {
    try {
      setLoading(true);
      await api.get('v1/recebidoxgastosummary', { params }).then((response) => {
        settotalpo(response.data.valorpo);
        setagfaturar(response.data.faltafaturado);
        setvalorfaturado(response.data.valorfaturado);
        setmensagem('');
        console.log(response.data.valorpo);
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
      headerName: 'Doc instalação',
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
      headerName: 'FAM Instalação',
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
      headerName: 'Pendências Obra',
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

  const gerarexcel = () => {
    const excelData = recebimentoxgastos.map((item) => {
      return {
        RFP: item.rfp,
        ID: item.id,
        Cliente: item.cliente,
        Sigla: item.site,
        Regional: item.regiona,
        'Situação Implantação': item.situacaoimplantacao,
        'Situação Integração': item.situacaodaintegracao,
        'Mos Real': item.mosreal,
        'Install Real': item.instalreal,
        'Integração Real': item.integreal,
        'Valor POs': item.valorpo,
        'Valor Faturado': item.valorfaturado,
        'Doc instalação': item.docinstalacao,
        'Doc Infra': item.docinfra,
        'FAM entrega': item.Statusfamentrega,
        'FAM Instalação': item.StatusfamInstalacao,
        Tipo: item.tipo,
        Aceitação: item.aceitacaofical,
        'Pendências Obra': item.PendenciasObra,
      };
    });
    exportExcel({ excelData, fileName: 'Relatorio_PO_x_Faturado' });
  };

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
              <Button color="link" onClick={() => gerarexcel()}>
              {' '}
              Exportar Excel
            </Button>
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
