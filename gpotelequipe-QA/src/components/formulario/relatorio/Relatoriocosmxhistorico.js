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



const Relatoriocosmxhistorico = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(10);
    const [loading, setLoading] = useState(false);
    const [historico, sethistorico] = useState([]);
    const [mensagem, setmensagem] = useState('');

    const relatoriohistoricocosmx = async () => {
        try {
            setLoading(true);
            const response = await api.get('v1/projetocosmx/relatoriohistoricopagamentocosmx');

            // Verifica se os dados são um array antes de configurar
            if (Array.isArray(response.data)) {
                sethistorico(response.data);
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
            field: 'nome',
            headerName: 'EMPRESA',
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
            field: 'porcentagem',
            headerName: '%',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },        
        {
            field: 'valor',
            headerName: 'VALOR',
            width: 180,
            valueFormatter: ({ value }) => {
              return new Intl.NumberFormat('pt-BR', {
                style: 'currency',
                currency: 'BRL',
              }).format(value);
            },
        },
        {
            field: 'dataenviofechamento',
            headerName: 'ENVIO FECHAMENTO',
            width: 200,
            align: 'left',
            type: 'string',
            editable: false,
            valueFormatter: ({ value }) => {
              // Certifique-se de que a data esteja no formato ISO ou um formato compatível
              if (value) {
                const date = new Date(value);
                return date.toLocaleDateString('pt-BR'); // Formata a data para o formato brasileiro (dd/mm/aaaa)
              }
              return '';
            },
          },      
        {
            field: 'NF',
            headerName: 'NOTA FISCAL PJ',
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
        relatoriohistoricocosmx();
    };




    useEffect(() => {
        iniciatabelas();
    }, []);

    const gerarexcel = () => {
        const excelData = historico.map((item) => ({

            "SITE (DE)": item.sitefromto,
            "SITE (PARA)": item.siteid,
            "UF": item.uf,
            "EMPRESA": item.nome,
            "PERÍODO DE EXECUÇÃO": item.fechamento,
            "%": item.porcentagem,
            "VALOR": item.valor,
            "ENVIO FECHAMENTO": item.dataenviofechamento,
            "NOTA FISCAL PJ": item.NF,




            /*
            Numero: item.numero,
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
        exportExcel({ excelData, fileName: 'Relatório - Histórico Pagamento Cosmx' });
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
                <ModalHeader>Relatório - Histórico Pagamento Cosmx</ModalHeader>
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
                                    rows={historico}
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

Relatoriocosmxhistorico.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Relatoriocosmxhistorico;
