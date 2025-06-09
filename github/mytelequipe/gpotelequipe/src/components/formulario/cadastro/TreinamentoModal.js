import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, Input, Button } from 'reactstrap';
import { Box } from '@mui/material';
import { DataGrid, gridPageCountSelector, gridPageSelector, useGridApiContext, useGridSelector } from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import exportExcel from '../../../data/exportexcel/Excelexport';

const TreinamentoModal = ({ isOpen, toggle, data, title }) => {
  const [searchTerm, setSearchTerm] = useState('');

  const filteredData = data.filter(item => {
    const nome = item.nome || '';
    const datavencimento = item.datavencimento || '';
    const descricao = item.descricao || '';
    return (
      nome.toLowerCase().includes(searchTerm.toLowerCase()) ||
      datavencimento.toLowerCase().includes(searchTerm.toLowerCase()) ||
      descricao.toLowerCase().includes(searchTerm.toLowerCase())
    );
  });

  const columns = [
    { field: 'datavencimento', headerName: 'Data de Vencimento', width: 200 },
    { field: 'nome', headerName: 'Nome', width: 300 },
    { field: 'descricao', headerName: 'Descrição', width: 200 },
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

  const gerarexcel = () => {

    const excelData = data.map((item) => {
      return {
       DataVencimento: item.datavencimento,
       Nome: item.nome,
       Descricao: item.descricao,
       //Equipe: item.nomegrupo,
       //Lider: item.lider,
      };
    });
    exportExcel({ excelData, fileName: title });
  };  

  return (
    <Modal isOpen={isOpen} toggle={toggle} size="lg" className="custom-modal">
      <ModalHeader toggle={toggle} style={{ backgroundColor: "white" }}>{title}</ModalHeader>
      <ModalBody style={{ backgroundColor: "white" }}>
        <Button color="link" onClick={() => gerarexcel()}>
          {' '}
          Exportar Excel
        </Button>
        <Input
          type="text"
          placeholder="Pesquisar por nome, data de vencimento ou descrição"
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

TreinamentoModal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  toggle: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      datavencimento: PropTypes.string.isRequired,
      nome: PropTypes.string.isRequired,
      descricao: PropTypes.string.isRequired,
    })
  ).isRequired,
  title: PropTypes.string.isRequired,
};

export default TreinamentoModal;