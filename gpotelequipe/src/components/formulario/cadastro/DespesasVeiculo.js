import { useState, useEffect } from 'react';
import { Modal, ModalHeader, ModalBody } from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  GridOverlay,
} from '@mui/x-data-grid';
import LinearProgress from '@mui/material/LinearProgress';
import PropTypes from 'prop-types';
import api from '../../../services/api';

const DespesasVeiculo = ({ show, setshow, idveiculo }) => {
  const [despesas, setDespesas] = useState([]);
  const [loading, setLoading] = useState(false);
  const [pageSize, setPageSize] = useState(10);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    idveiculo,
  };

  const listadespesas = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/despesas', { params });
      setDespesas(response.data);
    } catch (err) {
      // handle error if needed
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (show) {
      listadespesas();
    }
  }, [show]);

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  const columns = [
    { field: 'placa', headerName: 'Placa', width: 120, align: 'left' },
    { field: 'datalancamento', headerName: 'Data Lançamento', width: 150, align: 'center' },
    { field: 'categoria', headerName: 'Categoria', width: 150, align: 'left' },
    { field: 'valordespesa', headerName: 'Valor', width: 100, align: 'left' },
  ];

  const toggle = () => {
    setshow(!show);
  };

  return (
    <Modal isOpen={show} toggle={toggle} backdrop="static" className="modal-dialog modal-lg">
      <ModalHeader toggle={toggle} style={{ backgroundColor: 'white' }}>
        Despesas do Veículo
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        <Box sx={{ height: 400, width: '100%' }}>
          <DataGrid
            rows={despesas}
            columns={columns}
            loading={loading}
            pageSize={pageSize}
            onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
            disableSelectionOnClick
            components={{
              LoadingOverlay: LinearProgress,
              NoRowsOverlay: CustomNoRowsOverlay,
            }}
          />
        </Box>
      </ModalBody>
    </Modal>
  );
};

DespesasVeiculo.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  idveiculo: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
};

export default DespesasVeiculo;