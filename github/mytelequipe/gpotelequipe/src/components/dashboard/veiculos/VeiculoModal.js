import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, Input } from 'reactstrap';
import { Box } from '@mui/material';
import { DataGrid, GridActionsCellItem, gridPageCountSelector, gridPageSelector, useGridApiContext, useGridSelector } from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import { Edit as EditIcon } from '@mui/icons-material';
import Veiculosedicao from '../../formulario/cadastro/Veiculosedicao';

const VeiculoModal = ({ isOpen, toggle, data = [], title }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState(false);
  const [ididentificador, setididentificador] = useState(0);

  const alterarUser = (id) => {
    settelacadastroedicao(true);
    setididentificador(id);
  };

  const filteredData = data
    .filter(item =>
      item.placa.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.categoria.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.modelo.toLowerCase().includes(searchTerm.toLowerCase())
    )
    .map(item => ({
      ...item,
      inspecaoveicular: item.inspecaoveicular === '1899-12-30' ? '' : item.inspecaoveicular,
    }));

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
        />
      ],
    },
    { field: 'nome', headerName: 'Nome', width: 200 },
    { field: 'placa', headerName: 'Placa', width: 110 },
    { field: 'categoria', headerName: 'Categoria', width: 160 },
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
    <Modal isOpen={isOpen} toggle={toggle} size="lg">
      <ModalHeader toggle={toggle}>{title}</ModalHeader>
      <ModalBody>
        <Input
          placeholder="Pesquisar por placa, categoria ou modelo"
          value={searchTerm}
          onChange={e => setSearchTerm(e.target.value)}
        />
        <Box sx={{ height: 400, width: '100%', mt: 2 }}>
          <DataGrid
            rows={filteredData}
            columns={columns}
            pageSize={5}
            pagination
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
            titulotopo="Editar Veículos"
          />
        )}
      </ModalBody>
    </Modal>
  );
};

VeiculoModal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  toggle: PropTypes.func.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string.isRequired,
};

export default VeiculoModal;
