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

const Relatoriototalacionamentozte = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(10);
    const [loading, setLoading] = useState(false);
    const [totalacionamento, settotalacionamento] = useState([]);
    const [mensagem, setmensagem] = useState('');

    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        deletado: 0,
    };

    const listaacionamentos = async () => {
        try {
            setLoading(true);
            const response = await api.get('v1/projetozte/totalacionamento', { params });
            settotalacionamento(response.data);
            setmensagem('');
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setLoading(false);
        }
    };

    const columns = [
       // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
        {
            field: 'os',
            headerName: 'OS',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'po',
            headerName: 'PO',
            width: 230,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'sitename',
            headerName: 'SITENAME(DE)',
            width: 140,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'sitenamefrom',
            headerName: 'SITENAME(PARA)',
            width: 140,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'region',
            headerName: 'REGION',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'regiaobr',
            headerName: 'REGIONAL',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'state',
            headerName: 'STATE',
            width: 90,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'siteid',
            headerName: 'SITEID',
            width: 180,
            align: 'left',
            type: 'string',
            editable: false,
        },

        {
            field: 'ztecode',
            headerName: 'ZTECODE',
            width: 180,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'servicedescription',
            headerName: 'SERVICE DESCRIPTION',
            width: 400,
            align: 'left',
            type: 'string',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,            
        },
        {
            field: 'qty',
            headerName: 'QTY',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },

        {
            field: 'valorlpu',
            headerName: 'VALOR LPU',
            width: 120,
            align: 'right',
            type: 'number', // Melhor usar 'number' para valores monetários
            editable: false,
            valueFormatter: (parametros) => {
                if (parametros.value == null) return ''; // Caso o valor seja nulo
                return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
            },
        },
        {
            field: 'regiao',
            headerName: 'REGIÃO',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'historicolpu',
            headerName: 'HISTORICO LPU',
            width: 200,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'dataacionamento',
            headerName: 'DATA ACIONAMENTO',
            width: 200,
            align: 'center',
            type: 'date', // Use 'date' para o DataGrid entender o tipo
            editable: false,
            valueFormatter: (parametros) => {
                if (!parametros.value) return ''; // Caso o valor seja nulo
                const date = new Date(parametros.value);
                return date.toLocaleDateString('pt-BR');
            },
        },
        {
            field: 'nome',
            headerName: 'COLABORADOR',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
        },
        {
            field: 'statusdoc',
            headerName: 'STATUS DOC',
            width: 180,
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
        listaacionamentos();
    };

    useEffect(() => {
        iniciatabelas();
    }, []);

    const gerarexcel = () => {
        const excelData = totalacionamento.map((item) => ({
           
            "OS":  item.os,
            "PO":  item.po,
            "REGION":  item.region,
            "REGINONAL":  item.regiaobr,
            "STATE":  item.state,
            "SITEID":  item.siteid,
            "SITENAME(DE)":  item.sitename,
            "SITENAME(PARA)":  item.sitenamefrom,        
            "ZTECODE":  item.ztecode,
            "SERVICE DESCRIPTION":  item.servicedescription,
            "QTY":  item.qty,
            "VALOR LPU":  item.valorlpu,
            "REGIÃO":  item.regiao,            
            "HISTORICO LPU":  item.historicolpu,
            "DATA ACIONAMENTO":  item.dataacionamento,
            "COLABORADOR":  item.nome,                                                      
            "STATUS DOC":  item.statusdoc,      
    }));
        exportExcel({ excelData, fileName: 'Relatório - Total Acionamento' });
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
                <ModalHeader>Relatório - Total Acionamento</ModalHeader>
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

                            <Box sx={{ height: '100%', width: '100%' }}>
                                <DataGrid
                                    rows={totalacionamento}
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

Relatoriototalacionamentozte.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Relatoriototalacionamentozte;
