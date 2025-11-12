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
import Pessoasedicao from '../../formulario/cadastro/Pessoasedicao';

const CnhModal = ({ isOpen, toggle, data = [], title }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState(false);
  const [ididentificador, setididentificador] = useState(0);

  const filteredData = data
    .filter(item =>
      item.placa.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.nome.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.datavalidadecnh.toLowerCase().includes(searchTerm.toLowerCase())
    )
    .map(item => ({
      ...item,
      datavalidadecnh: item.datavalidadecnh === '1899-12-30' ? '' : item.datavalidadecnh,
    }));

  const alterarUser = (idpessoa) => {
    settelacadastroedicao(true);
    setididentificador(idpessoa);
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
          label="Editar"
          onClick={() => alterarUser(params.row.idpessoa)}
          showInMenu={false}
        />,
      ],
    },
    { field: 'nome', headerName: 'Nome', width: 300 },
    { field: 'placa', headerName: 'Placa', width: 110 },
    {
      field: 'datavalidadecnh',
      headerName: 'Validade CNH',
      width: 130,
      valueFormatter: (params) => {
        const dateStr = params.value;
        if (dateStr && dateStr !== '1899-12-30') {
          const [year, month, day] = dateStr.split('-');
          return `${day}-${month}-${year}`;
        }
        return '';
      },
    },
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
          placeholder="Pesquisar por placa, nome ou validade da CNH"
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
        {telacadastroedicao && (
          <Pessoasedicao
            show={telacadastroedicao}
            setshow={settelacadastroedicao}
            ididentificador={ididentificador}
            atualiza={() => {}}
            titulotopo="Editar Pessoa"
          />
        )}
      </ModalBody>
    </Modal>
  );
};

CnhModal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  toggle: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(
    PropTypes.shape({
      nome: PropTypes.string.isRequired,
      id: PropTypes.number.isRequired,
      placa: PropTypes.string.isRequired,
      datavalidadecnh: PropTypes.string.isRequired,
      modelo: PropTypes.string.isRequired,
    })
  ).isRequired,
  title: PropTypes.string.isRequired,
};

export default CnhModal;