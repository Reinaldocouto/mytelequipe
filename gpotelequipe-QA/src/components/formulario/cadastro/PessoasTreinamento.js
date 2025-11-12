import { useEffect, useState } from 'react';
import { Button, CardBody, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import { Box } from '@mui/material';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Pessoastreinamento = ({ setshow, show, atualiza }) => {
  const [loading, setLoading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const columns = [
    {
      field: 'nome',
      headerName: 'Nome',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'dataemissao',
      headerName: 'Data de emissão',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'idtreinamento',
      headerName: 'Id treinamento',
      type: 'string',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'datavencimento',
      headerName: 'Data de Vencimento',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      type: 'string',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'situacao',
      headerName: 'Situação',
      type: 'string',
      width: 200,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'funcao',
      headerName: 'Função',
      type: 'string',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      type: 'string',
      width: 200,
      align: 'rigth',
      editable: false,
    }, 
  ];
  const toggleModal = () => {
    console.log(atualiza);
    setshow(!show);
  };
  useEffect(() => {
    setLoading(false);
  }, []);

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
  function gerarexcel() {
    const excelData = atualiza.map((item) => {
      return {
        Nome: item.nome,
        'Data de emissão': item.dataemissao,
        'Id treinamento': item.idtreinamento,
        'Data de vencimento': item.datavencimento,
        Descrição: item.descricao,
        Situação: item.situacao,
      };
    });
    exportExcel({ excelData, fileName: 'Treinamento Geral' });
  }

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggleModal}
        className="modal-dialog modal-xl modal-dialog-scrollable  modal-fullscreen  "
      >
        <ModalHeader toggle={toggleModal}>Treinamentos Geral</ModalHeader>
        <ModalBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => gerarexcel()}>
              Exportar Excel
            </Button>
            <Box
              sx={{
                height: atualiza.length > 0 ? '100%' : 500,
                width: '100%',
                textAlign: 'right',
              }}
            >
              <DataGrid
                rows={atualiza}
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
                //opções traduzidas da tabela
                localeText={{
                  // Column menu text
                  columnMenuShowColumns: 'Mostra Colunas',
                  columnMenuManageColumns: 'Gerencia Colunas',
                  columnMenuFilter: 'Filtro',
                  columnMenuHideColumn: 'Esconder',
                  columnMenuUnsort: 'Desordenar',
                  columnMenuSortAsc: 'Classificar por Crescente',
                  columnMenuSortDesc: 'Classificar por Decrescente',
                }}
              />
            </Box>
          </CardBody>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggleModal.bind(null)}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};
Pessoastreinamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  atualiza: PropTypes.node.isRequired,
};
export default Pessoastreinamento;
