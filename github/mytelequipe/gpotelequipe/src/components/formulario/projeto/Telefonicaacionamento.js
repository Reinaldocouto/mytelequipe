import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
    DataGrid,
    gridPageCountSelector,
    gridPageSelector,
    useGridApiContext,
    GridActionsCellItem,
    useGridSelector,
    GridOverlay,
    ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import {
    Modal,
    ModalHeader,
    ModalBody,
    Card,
    CardBody,
    Button,
    Input,
    InputGroup
} from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Typography from '@mui/material/Typography';
import EditIcon from '@mui/icons-material/Edit';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';
//import Notpermission from '../../layouts/notpermission/notpermission';
import Telefonicaacionamentoedicao from './Telefonicaacionamentoedicao';

const Telefonicaacionamento = ({ setshow, show }) => {
    const [projeto, setprojeto] = useState([]);
    const [paginationModel, setPaginationModel] = useState({ pageSize: 10, page: 0 });
    const [loading, setloading] = useState(false);
    const [pesqgeral, setpesqgeral] = useState('');
    const [mensagem, setmensagem] = useState('');
    const [mensagemsucesso, setmensagemsucesso] = useState('');
    const [ididentificador, setididentificador] = useState(0);
    const [telacadastroedicao, settelacadastroedicao] = useState('');
    const [titulo, settitulo] = useState('');


    const togglecadastro = () => {
        setshow(!show);
    };

    console.log(setprojeto);
    console.log(setloading);

    const params = {
        busca: pesqgeral,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        deletado: 0,
    };

    function CustomNoRowsOverlay() {
        return (
            <GridOverlay>
                <div>Nenhum dado encontrado.</div>
            </GridOverlay>
        );
    }

    function CustomPagination() {
        const apiRef = useGridApiContext();
        const page = useGridSelector(apiRef, gridPageSelector);
        const pageCount = useGridSelector(apiRef, gridPageCountSelector);
        const rowCount = apiRef.current.getRowsCount(); // Obtém total de itens
        return (
            <Box
                sx={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    width: '100%',
                    padding: '10px'
                }}
            >
                {/* Texto com total de itens alinhado à esquerda */}
                <Typography variant="body2">
                    Total de itens: {rowCount}
                </Typography>

                {/* Componente de paginação alinhado à direita */}
                <Pagination
                    color="primary"
                    count={pageCount}
                    page={page + 1}
                    onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
                />
            </Box>

        );
    }


    const lista = async () => {
        setmensagemsucesso('');
        try {
            setloading(true);
            await api.get('v1/projetotelefonica/listaacionamento', { params }).then((response) => {
                setprojeto(response.data);
                console.log(response.data);
                setpesqgeral('');
                setmensagem('');
            });
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    };


    function alterarUser(stat) {
        setididentificador(stat);
        settelacadastroedicao(true);
        settitulo('Alterar');
    }


    /* function userpermission() {
       const permissionstorage = JSON.parse(localStorage.getItem('permission'));
       setpermission(permissionstorage.ericsson === 1);
     } */







    const columns = [
        {
            field: 'actions',
            headerName: 'Ação',
            type: 'actions',
            width: 80,
            align: 'center',
            getActions: (parametros) => [
                <GridActionsCellItem
                    icon={<EditIcon />}
                    label="Alterar"
                    onClick={() => alterarUser(parametros.id)}
                />,
            ],
        },
        // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
        /*  {
            field: 'rfp',
            headerName: 'RFP > Nome',
            width: 180,
            align: 'left',
            editable: false,
          }, */
        {
            field: 'uidIdpmts',
            headerName: 'IDPMTS',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'uidUfsigla',
            headerName: 'UFSIGLA',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'uidIdcpomrf',
            headerName: 'IDCPOMRF',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'pmoUf',
            headerName: 'UF',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'pmoRegional',
            headerName: 'REGIONAL',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'vendorVistoria',
            headerName: 'VISTORIA',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'vendorIntegrador',
            headerName: 'INTEGRADOR',
            width: 150,
            align: 'left',
            editable: false,
        },
    ];

    const iniciatabelas = () => {
        // lista();
    };

    const gerarexcel = () => {
        const excelData = projeto.map((item) => {
            return {
                "OS": item.os,
                "PO": item.po,
                "REGION": item.region,
                "REGINONAL": item.regiaobr,
                "STATE": item.state,
                "SITEID": item.siteid,
                "SITENAME(DE)": item.sitename,
                "SITENAME(PARA)": item.sitenamefrom,
            };
        });
        exportExcel({ excelData, fileName: 'projeto ZTE' });
    };

    useEffect(() => {
        iniciatabelas();
    }, []);

    return (
        <Modal
            isOpen={show}
            toggle={togglecadastro.bind(null)}
            backdrop="static"
            keyboard={false}
            className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
        >
            <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: "white" }}>Obras Telefonica Acionamento</ModalHeader>
            <ModalBody style={{ backgroundColor: "white", padding: "0px" }}>
                <div>
                    <Card>
                        <CardBody style={{ backgroundColor: 'white', marginBottom: "-35px" }}>
                            {mensagem.length !== 0 ? (
                                <div className="alert alert-danger mt-2" role="alert">
                                    {mensagem}
                                </div>
                            ) : null}
                            {mensagemsucesso.length > 0 ? (
                                <div className="alert alert-success" role="alert">
                                    {' '}
                                    {mensagemsucesso}
                                </div>
                            ) : null}
                            {telacadastroedicao ? (
                                <>
                                    {' '}
                                    <Telefonicaacionamentoedicao
                                        show={telacadastroedicao}
                                        setshow={settelacadastroedicao}
                                        ididentificador={ididentificador}
                                        atualiza={lista}
                                        titulo={titulo}
                                    />{' '}
                                </>
                            ) : null}

                            <div className="row g-3">
                                <div className="col-sm-6">
                                    Pesquisa
                                    <InputGroup>
                                        <Input
                                            type="text"
                                            onChange={(e) => setpesqgeral(e.target.value)}
                                            value={pesqgeral}
                                        ></Input>
                                        <Button color="primary" onClick={lista}>
                                            {' '}
                                            <SearchIcon />
                                        </Button>
                                        <Button color="primary" onClick={lista}>
                                            {' '}
                                            <AutorenewIcon />
                                        </Button>
                                    </InputGroup>
                                </div>

                            </div>
                        </CardBody>
                        <CardBody style={{ backgroundColor: 'white' }}>
                            <Button color="link" onClick={() => gerarexcel()}>
                                {' '}
                                Exportar Excel
                            </Button>
                            <Box sx={{ height: projeto.length > 0 ? '100%' : 500, width: '100%' }}>
                                <DataGrid
                                    rows={projeto}
                                    columns={columns}
                                    loading={loading}
                                    disableSelectionOnClick
                                    experimentalFeatures={{ newEditingApi: true }}
                                    components={{
                                        Pagination: CustomPagination,
                                        LoadingOverlay: LinearProgress,
                                        NoRowsOverlay: CustomNoRowsOverlay,
                                    }}
                                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}

                                    // Usa estado para controlar a paginação dinamicamente
                                    paginationModel={paginationModel}
                                    onPaginationModelChange={setPaginationModel}
                                />
                            </Box>
                        </CardBody>
                    </Card>
                </div>

            </ModalBody>


        </Modal>
    );


};

Telefonicaacionamento.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Telefonicaacionamento;
