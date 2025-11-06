import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, Input } from 'reactstrap';
import { Box } from '@mui/material';
import { DataGrid, gridPageCountSelector, gridPageSelector, useGridApiContext, useGridSelector } from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';

const PessoaModal = ({ isOpen, toggle, data = [], title }) => {
  const [searchTerm, setSearchTerm] = useState('');

  const filteredData = data.filter(item =>
    item.nome.toLowerCase().includes(searchTerm.toLowerCase()) ||
    item.inativacao.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const columns = [
    { field: 'nome', headerName: 'Nome', width: 300 },
    { field: 'inativacao', headerName: 'Data de Inativação', width: 200 },
    { field: 'empresanome', headerName: 'Empresa', width: 200 },
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
      <ModalHeader toggle={toggle} style={{backgroundColor: "white"}}>{title}</ModalHeader>
      <ModalBody style={{backgroundColor: "white"}}>
        <Input
          type="text"
          placeholder="Pesquisar por nome ou data de inativação"
          value={searchTerm}
          onChange={e => setSearchTerm(e.target.value)}
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
      </ModalBody>
    </Modal>
  );
};

PessoaModal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  toggle: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      nome: PropTypes.string.isRequired,
      inativacao: PropTypes.string.isRequired,
      empresanome: PropTypes.string.isRequired,
    })
  ).isRequired,
  title: PropTypes.string.isRequired,
};

export default PessoaModal;