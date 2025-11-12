import { useState } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, ModalFooter, Button, Input } from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import { Edit as EditIcon } from '@mui/icons-material';
import api from '../../../services/api';
import Veiculosedicao from '../../formulario/cadastro/Veiculosedicao';
import modoVisualizador from '../../../services/modovisualizador';


const InspecaoPeriodicaModal = ({
  isOpen,
  toggle,
  data = [],
  title,
  refreshData,
  originalData,
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedRow, setSelectedRow] = useState(null);
  const [newKm, setNewKm] = useState('');
  const [kmsrestante, setKmsRestante] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState(false);
  const [ididentificador, setididentificador] = useState(0);

  const alterarUser = (id) => {
    settelacadastroedicao(true);
    setididentificador(id);
  };

  const calcularKmsRestante = (kmAtualValue = newKm, km4Value = selectedRow?.km4) => {
    const proximaRevisao = parseInt(km4Value, 10) + 10000;
    const restante = proximaRevisao - parseInt(kmAtualValue, 10);
    setKmsRestante(restante >= 0 ? restante : 0);
  };

  const getStatus = (kmsRestanteParam) => {
    if (kmsRestanteParam <= 0) return 'Irregular';
    if (kmsRestanteParam > 0 && kmsRestanteParam <= 1000) return 'A vencer';
    return 'Ativo';
  };

  const filteredData = data
    .filter(
      (item) =>
        item.placa.toLowerCase().includes(searchTerm.toLowerCase()) ||
        item.nome?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        item.categoria?.toLowerCase().includes(searchTerm.toLowerCase()),
    )
    .map((item) => ({
      ...item,
      inspecaoveicular: item.inspecaoveicular === '1899-12-30' ? '' : item.inspecaoveicular,
      status: getStatus(item.kmsrestante),
    }));

  const handleEditClick = (row) => {
    setSelectedRow(row);
    setNewKm(row.kmatual);
    calcularKmsRestante(row.kmatual, row.km4);
  };

  const handleKmAtualChange = (e) => {
    const kmAtualValue = e.target.value;
    setNewKm(kmAtualValue);
    calcularKmsRestante(kmAtualValue);
  };

  const handleSaveKm = async () => {
    if (selectedRow) {
      const { id, ...rest } = selectedRow;
      const original = originalData[id] || {};
      const updatedData = {
        ...rest,
        idveiculo: id,
        kmatual: newKm,
        kmsrestante: kmsrestante.toString(),
        ativo: original.status,
        inspecaoVeicular: original.inspecaoveicular,
      };

      try {
        const response = await api.post('v1/veiculos', updatedData);
        if (response.status === 201) {
          //console.log('Status: ', original.status);
          //console.log('Inspeção veicular: ', original.inspecaoveicular);
          //console.log("dados: ", updatedData);
          setSelectedRow(null);
          toggle();
          refreshData();
        } else {
          console.error('Erro ao atualizar o KM');
        }
      } catch (error) {
        console.log('dados: ', updatedData);
        console.error('Erro na atualização do KM:', error);
      }
    }
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
    {
      field: 'editKm',
      headerName: 'Edit Km',
      width: 80,
      renderCell: (params) => (
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Editar KM"
          onClick={() => handleEditClick(params.row)}
          showInMenu={false}
        />
      ),
    },
    { field: 'placa', headerName: 'Placa', width: 110 },
    { field: 'nome', headerName: 'Condutor', width: 200 },
    { field: 'categoria', headerName: 'Categoria', width: 160 },
    { field: 'kmatual', headerName: 'KM Atual', width: 120 },
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
    <>
      <Modal isOpen={isOpen} toggle={toggle} size="lg">
        <ModalHeader toggle={toggle}>{title}</ModalHeader>
        <ModalBody>
          <Input
            placeholder="Pesquisar por placa, condutor ou categoria"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
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
              disableSelectionOnClick
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

      {selectedRow && (
        <Modal isOpen={!!selectedRow} toggle={() => setSelectedRow(null)}>
          <ModalHeader toggle={() => setSelectedRow(null)}>
            Editar KM Atual para {selectedRow.placa}
          </ModalHeader>
          <ModalBody>
            <Input
              type="number"
              value={newKm}
              onChange={handleKmAtualChange}
              placeholder="Digite o novo KM Atual"
            />
            <p>KMs até a próxima revisão: {kmsrestante}</p>
          </ModalBody>
          <ModalFooter>
            <Button color="primary" onClick={handleSaveKm} disabled={modoVisualizador()}>
              Salvar
            </Button>
            <Button color="secondary" onClick={() => setSelectedRow(null)}>
              Cancelar
            </Button>
          </ModalFooter>
        </Modal>
      )}
    </>
  );
};

InspecaoPeriodicaModal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  toggle: PropTypes.func.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string.isRequired,
  refreshData: PropTypes.func.isRequired,
  originalData: PropTypes.object.isRequired,
};

export default InspecaoPeriodicaModal;
