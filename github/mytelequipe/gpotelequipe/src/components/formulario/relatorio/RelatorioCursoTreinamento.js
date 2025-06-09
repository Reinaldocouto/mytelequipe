import React, { useState, useEffect } from 'react';
import {
    Button,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter,
    FormGroup,
    Input,
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
import Select from 'react-select';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';

const RelatorioTreinamento = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(10);
    const [loading, setLoading] = useState(false);
    const [treinamentos, setTreinamentos] = useState([]);
    const [filteredTreinamentos, setFilteredTreinamentos] = useState([]);
    const [mensagem, setMensagem] = useState('');
    const [selectedSituacao, setSelectedSituacao] = useState('');
    const [selectedNome, setSelectedNome] = useState(null);

    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        deletado: 0,
    };

    const listTreinamentos = async () => {
        try {
            setLoading(true);
            await api.get('v1/pessoa/treinamentogeral', { params }).then((response) => {
                setTreinamentos(response.data);
                setFilteredTreinamentos(response.data);
                setMensagem('');
            });
        } catch (err) {
            setMensagem(err.message);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        console.log("Treinamentos atualizados:", treinamentos); // Debug: Verifique o estado após a atualização
    }, [treinamentos]);

    const handleFilter = () => {
        let filteredData = treinamentos;
        if (selectedSituacao) {
            filteredData = filteredData.filter(item => item.situacao === selectedSituacao);
        }
        if (selectedNome) {
            filteredData = filteredData.filter(item => item.nome === selectedNome.value);
        }
        setFilteredTreinamentos(filteredData);
    };

    const uniqueNomes = Array.from(new Set(treinamentos.map(item => item.nome))).sort().map(nome => ({ value: nome, label: nome }));

    const columns = [
        { field: 'id', headerName: 'ID', width: 80, align: 'center' },
        { field: 'idpessoa', headerName: 'ID Pessoa', width: 120, align: 'left' },
        { field: 'nome', headerName: 'Nome', width: 300, align: 'left', renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div> },
        { field: 'idtreinamento', headerName: 'ID Treinamento', width: 120, align: 'left' },
        { field: 'descricao', headerName: 'Descrição', width: 300, align: 'left', renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div> },
        { field: 'dataemissao', headerName: 'Data Emissão', width: 150, align: 'left' },
        { field: 'datavencimento', headerName: 'Data Vencimento', width: 150, align: 'left' },
        { field: 'situacao', headerName: 'Situação', width: 150, align: 'left' },
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
        listTreinamentos();
    };

    useEffect(() => iniciatabelas(), []);

    const gerarexcel = () => {
        const excelData = treinamentos.map((item) => {
          return {
            ID: item.id,
            "ID Pessoa": item.idpessoa,
            Nome: item.nome,
            "ID Treinamento": item.idtreinamento,
            Descrição: item.descricao,
            'Data Emissão': item.dataemissao,
            'Data Vencimento': item.datavencimento,
            Situação: item.situacao,
          };
        });
        exportExcel({ excelData, fileName: 'Relatorio_Treinamento' });
      };

    return (
        <>
            <Modal
                isOpen={show}
                toggle={toggle.bind(null)}
                backdrop="static"
                keyboard={false}
                className="modal-dialog modal-fullscreen modal-dialog-scrollable"
            >
                <ModalHeader>Relatório de Treinamento</ModalHeader>

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
                            <div className="row g-3">
                                <div className="col-md-5">
                                    <FormGroup>
                                        <Select
                                            isClearable
                                            isSearchable
                                            name="nome"
                                            id="nome"
                                            options={uniqueNomes}
                                            placeholder="Selecione ou digite um nome"
                                            value={selectedNome}
                                            onChange={(selectedOption) => setSelectedNome(selectedOption)}
                                        />
                                    </FormGroup>
                                </div>
                                <div className="col-md-5">
                                    <FormGroup>
                                        <Input
                                            type="select"
                                            name="situacao"
                                            id="situacao"
                                            value={selectedSituacao}
                                            onChange={(e) => setSelectedSituacao(e.target.value)}
                                        >
                                            <option value="">Selecione uma situação</option>
                                            <option value="VALIDO">Válido</option>
                                            <option value="VENCIDO">Vencido</option>
                                            <option value="RENOVAR">Renovar</option>
                                        </Input>
                                    </FormGroup>
                                </div>
                                <div className="col-md-2">
                                    <div className="row">
                                        <div className="col-12 d-flex justify-content-end">
                                            <Button color="primary" onClick={handleFilter}>
                                                Filtrar
                                            </Button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <Button color="link" onClick={() => gerarexcel()}>
                              {' '}
                              Exportar Excel
                            </Button>
                            <Box sx={{ height: '100%', width: '100%' }}>
                                <DataGrid
                                    rows={filteredTreinamentos}
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
                    <Button color="secondary" onClick={toggle.bind(null)}>
                        Fechar
                    </Button>
                </ModalFooter>
            </Modal>
        </>
    );
};

RelatorioTreinamento.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default RelatorioTreinamento;
