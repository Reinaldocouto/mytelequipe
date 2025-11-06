import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, Input } from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridActionsCellItem,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import EditIcon from '@mui/icons-material/Edit';
import Veiculosedicao from '../../formulario/cadastro/Veiculosedicao';

const InspecaoModal = ({ isOpen, toggle, data = [], title }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState(false);
  const [ididentificador, setididentificador] = useState(0);

  const filteredData = data.filter((item) =>
    item.placa.toLowerCase().includes(searchTerm.toLowerCase()) ||
    item.nome.toLowerCase().includes(searchTerm.toLowerCase()) ||
    item.inspecaoveicular.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const alterarUser = (id) => {
    settelacadastroedicao(true);
    setididentificador(id);
  };

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 70,
      align: 'center',
      getActions: (params) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          hint="Alterar"
          onClick={() => alterarUser(params.id)}
        />,
      ],
    },
    { field: 'nome', headerName: 'Nome', width: 300 },
    { field: 'placa', headerName: 'Placa', width: 110 },
    { field: 'inspecaoveicular', headerName: 'Inspeção Veicular', width: 130 },
    { field: 'modelo', headerName: 'Modelo', width: 200 },
  ];

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

  return (
    <Modal isOpen={isOpen} toggle={toggle} size="lg" className="custom-modal">
      <ModalHeader toggle={toggle} style={{ backgroundColor: "white" }}>{title}</ModalHeader>
      <ModalBody style={{ backgroundColor: "white" }}>
        <Input
          type="text"
          placeholder="Pesquisar por placa, nome ou inspeção veicular"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="mb-3"
        />
        <Box sx={{ height: 550, width: '100%' }}>
          <DataGrid
            rows={filteredData}
            columns={columns}
            pageSize={5}
            rowsPerPageOptions={[5]}
            disableSelectionOnClick
            getRowId={(row) => row.id}
            components={{
              Pagination: CustomPagination,
            }}
          />
        </Box>
        {telacadastroedicao && (
          <Veiculosedicao
            show={telacadastroedicao}
            setshow={settelacadastroedicao}
            ididentificador={ididentificador}
            atualiza={() => {}}
            titulotopo='Editar Veículos'
          />
        )}
      </ModalBody>
    </Modal>
  );
};

InspecaoModal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  toggle: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(
    PropTypes.shape({
      nome: PropTypes.string.isRequired,
      id: PropTypes.number.isRequired,
      placa: PropTypes.string.isRequired,
      inspecaoveicular: PropTypes.string.isRequired,
      modelo: PropTypes.string.isRequired,
    })
  ).isRequired,
  title: PropTypes.string.isRequired,
};

export default InspecaoModal;
