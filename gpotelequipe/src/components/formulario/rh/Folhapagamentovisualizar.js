import { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import { Box } from '@mui/material';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import PropTypes from 'prop-types';
import { jsPDF as JsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';

import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';

const Folhapagamentovisualizar = ({ setshow, show, ididentificador, titulo, periodo }) => {
  const [mensagem, setmensagem] = useState('');
  const [loading, setloading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [folhalista, setfolhalista] = useState([]);

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    codigo: ididentificador,
    datafolha: periodo,
    deletado: 0,
  };

  const folhaid = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/rh/folhapagamentoid', { params });
      setfolhalista(response.data || []);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const columns = [
    {
      field: 'codlancamento',
      headerName: 'Cod. Lanc.',
      type: 'number',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'lancamento',
      headerName: 'Lancamento',
      type: 'string',
      width: 250,
      align: 'left',
      editable: false,
    },
    {
      field: 'referencia',
      headerName: 'Referencia',
      type: 'string',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'provento',
      headerName: 'Provento',
      type: 'number',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'desconto',
      headerName: 'Desconto',
      type: 'string',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'bases',
      headerName: 'Bases',
      type: 'string',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'liquido',
      headerName: 'Liquido',
      type: 'string',
      width: 100,
      align: 'right',
      editable: false,
    },
  ];

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Folha não disponível para este período</div>
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

  const handlePrint = () => {
    if (folhalista.length === 0) {
      setmensagem('Não há dados para gerar o PDF');
      return;
    }

    const doc = new JsPDF();

    // Add title
    doc.setFontSize(16);
    doc.text(titulo, 14, 15);
    doc.setFontSize(12);
    doc.text(`Período: ${periodo}`, 14, 25);

    // Generate table
    autoTable(doc, {
      head: [columns.map((col) => col.headerName)],
      body: folhalista.map((row) => [
        row.codlancamento,
        row.lancamento,
        row.referencia,
        row.provento,
        row.desconto,
        row.bases,
        row.liquido,
      ]),
      startY: 30,
      styles: { fontSize: 8 },
      headStyles: { fillColor: [41, 128, 185], textColor: 255 },
      alternateRowStyles: { fillColor: [245, 245, 245] },
    });

    // Add footer
    const pageCount = doc.internal.getNumberOfPages();
    for (let i = 1; i <= pageCount; i++) {
      doc.setPage(i);
      doc.setFontSize(8);
      doc.text(
        `Página ${i} de ${pageCount} - Gerado em ${new Date().toLocaleDateString()}`,
        doc.internal.pageSize.width - 14,
        doc.internal.pageSize.height - 10,
        { align: 'right' },
      );
    }

    // Save the PDF
    doc.save(`folha-de-pagamento-${periodo}.pdf`);
  };
  useEffect(() => {
    if (show) {
      folhaid();
    }
  }, [show]);

  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-dialog-scrollable"
    >
      <ModalHeader toggle={togglecadastro}>{titulo}</ModalHeader>
      <ModalBody>
        {mensagem && (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        )}
        {loading ? (
          <Loader />
        ) : (
          <>
            <Box sx={{ height: folhalista.length > 0 ? '100%' : 500, width: '100%' }}>
              <DataGrid
                rows={folhalista}
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
                getRowId={(row) =>
                  `${row.lancamento ?? ''}${row.codigo ?? ''}${row.codlancamento ?? ''}`
                }
              />
            </Box>
          </>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="link" onClick={handlePrint} disabled={loading || folhalista.length === 0}>
          Gerar PDF
        </Button>
        <Button color="secondary" onClick={togglecadastro}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Folhapagamentovisualizar.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  titulo: PropTypes.string,
  periodo: PropTypes.string,
};

export default Folhapagamentovisualizar;
