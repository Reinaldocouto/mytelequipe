import React, { useState, useEffect } from 'react';
import {
    Button,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
    DataGrid,
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



const Relatoriocosmxconsolidado = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(10);
    const [loading, setLoading] = useState(false);
    const [consolidado, setconsolidado] = useState([]);
    const [mensagem, setmensagem] = useState('');

    const relatorioconsolidadocosmx = async () => {
        try {
            setLoading(true);
            const response = await api.get('v1/projetocosmx/relatorioconsolidadocosmx');

            // Verifica se os dados são um array antes de configurar
            if (Array.isArray(response.data)) {
                setconsolidado(response.data);
            } else {
                throw new Error('Os dados recebidos não são válidos.');
            }

            setmensagem('');
        } catch (err) {
            // Mensagem de erro mais clara
            setmensagem(`Erro ao buscar dados: ${err.message}`);
        } finally {
            setLoading(false);
        }
    };

    const columns = [
        // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
        {
            field: 'nome',
            headerName: 'NOME',
            width: 450,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'fechamento',
            headerName: 'FECHAMENTO',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'totalperiodo',
            headerName: 'TOTAL PERIODO',
            width: 180,
            valueFormatter: ({ value }) => {
              return new Intl.NumberFormat('pt-BR', {
                style: 'currency',
                currency: 'BRL',
              }).format(value);
            },
        },
        {
            field: 'NF',
            headerName: 'NOTA FISCAL',
            width: 100,
            align: 'left',
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
        relatorioconsolidadocosmx();
    };




    useEffect(() => {
        iniciatabelas();
    }, []);

    const gerarexcel = () => {
        const excelData = consolidado.map((item) => ({

            "NOME": item.nome,
            "FECHAMENTO": item.fechamento,
            "TOTAL PERÍODO": item.totalperiodo,
            "NOTA FISCAL": item.nota,


        }));
        exportExcel({ excelData, fileName: 'Relatório - Consolidado Pagamento Cosmx' });
    };

    return (
        <>
            <Modal
                isOpen={show}
                toggle={toggle}
                backdrop="static"
                keyboard={false}
                className="modal-dialog modal-fullscreen modal-dialog-scrollable"
            >
                <ModalHeader>Relatório - Consolidado Pagamento Cosmx </ModalHeader>
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
                            <Button color="link" onClick={gerarexcel}>
                                Exportar Excel
                            </Button>

                            <Box sx={{ height: '90%', width: '100%' }}>
                                <DataGrid
                                    rows={consolidado}
                                    columns={columns}
                                    loading={loading}
                                    pageSize={pageSize}
                                    onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                                    disableSelectionOnClick
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
                </ModalBody>
                <ModalFooter>
                    <Button color="secondary" onClick={toggle}>
                        Fechar
                    </Button>
                </ModalFooter>
            </Modal>
        </>
    );
};

Relatoriocosmxconsolidado.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Relatoriocosmxconsolidado;
