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



const Relatoriocosmxcontrole = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(10);
    const [loading, setLoading] = useState(false);
    const [controle, setcontrole] = useState([]);
    const [mensagem, setmensagem] = useState('');

    const relatoriocontrolecosmx = async () => {
        try {
            setLoading(true);
            const response = await api.get('v1/projetocosmx/relatoriocontrolecosmx');

            // Verifica se os dados são um array antes de configurar
            if (Array.isArray(response.data)) {
                setcontrole(response.data);
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
            field: 'po',
            headerName: 'PO',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'siteid',
            headerName: 'SITE (DE)',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'sitefromto',
            headerName: 'SITE (PARA)',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },     
        {
            field: 'uf',
            headerName: 'UF',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'region',
            headerName: 'REGIÃO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },        
        {
            field: 'nome',
            headerName: 'EMPRESA',
            width: 450,
            align: 'left',
            type: 'string',
            editable: false,
        },        
        {
            field: 'fechamento',
            headerName: 'PERÍODO EXECUÇÃO',
            width: 150,
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
        relatoriocontrolecosmx();
    };




    useEffect(() => {
        iniciatabelas();
    }, []);

    const gerarexcel = () => {
        const excelData = controle.map((item) => ({
            
            'PO': item.po,
            "SITE (DE)": item.sitefromto,
            "SITE (PARA)": item.siteid,
            "UF": item.uf,
            "REGIÃO": item.region,
            "EMPRESA": item.nome,
            "PERÍODO DE EXECUÇÃO": item.fechamento,
            
            
            
            
            /*Numero: item.numero,
            PO: item.po,
            "PO ITEM": item.poitem,
            NOME: item.nome,
            'CODIGO SERVIÇO': item.codigoservico,
            'DESCRIÇÃO SERVIÇO': item.descricaoservico,
            "VALOR SERVIÇO": item.valorservico,
            "LPU HISTÓRICO": item.lpuhistorico,
            "DATA ENVIO EMAIL": item.datadeenviodoemail ? new Date(item.datadeenviodoemail).toLocaleString('pt-BR', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
            }) : '',*/
        }));
        exportExcel({ excelData, fileName: 'Relatório - Obras Cosmx Controle' });
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
                <ModalHeader>Relatório - Obras Cosmx Controle</ModalHeader>
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
                                    rows={controle}
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

Relatoriocosmxcontrole.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Relatoriocosmxcontrole;
