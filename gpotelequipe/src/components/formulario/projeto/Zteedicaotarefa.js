import { useState, useEffect } from 'react';
import {
    Button,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter,
    Row,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
    DataGrid,
    gridPageCountSelector,
    gridPageSelector,
    useGridApiContext,
    useGridSelector,
    GridOverlay
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import PropTypes from 'prop-types';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import modoVisualizador from '../../../services/modovisualizador';

const Zteedicaotarefa = ({ setshow, show, ididentificador, atualiza, titulotopo, region, sitename,sitenamefrom, estado, siteid}) => {   //,  

    const [mensagem, setmensagem] = useState('');
    const [mensagemsucesso, setmensagemsucesso] = useState('');
    const [loading, setloading] = useState(false);
    const [tarefas, settarefas] = useState([]);
    const [rowSelectionModel, setRowSelectionModel] = useState([]);
    const [pageSize, setPageSize] = useState(10);


    console.log(atualiza);
    console.log(setmensagem);
    console.log(setmensagemsucesso);
    console.log(setloading);

    //Parametros
    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idprodutobusca: ididentificador,
        regiao: region,
        deletado: 0
    };

    function CustomPagination() {
        const apiRef = useGridApiContext();
        const page = useGridSelector(apiRef, gridPageSelector);
        const pageCount = useGridSelector(apiRef, gridPageCountSelector);

        return (
            <Pagination
                color="secondary"
                count={pageCount}
                page={page + 1}
                onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
            />
        );
    }

    function CustomNoRowsOverlay() {
        return (
            <GridOverlay>
                <div>Nenhum dado encontrado</div>
            </GridOverlay>
        );
    }


    const togglecadastro = () => {
        setshow(!show);
    };

    const listatarefa = async () => {
        setmensagemsucesso('');
        try {
            setloading(true);
            await api.get('v1/projetozte/tarefas', { params }).then((response) => {
                settarefas(response.data);
                setmensagem('');
            });
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    };

    const handleProcessRowUpdate = (newRow) => {
        // Atualiza o array de tarefas com a nova linha editada
        const updatedRows = tarefas.map((row) =>
            row.id === newRow.id ? newRow : row
        );
        settarefas(updatedRows); // Atualiza o estado com os novos dados
        return newRow; // Retorna a nova linha para o DataGrid
    };


    //tabela barras adicional    
    const tarefascolunas = [
        {
            field: 'ztecode',
            headerName: 'ZTECode',
            width: 200,
            type: 'string',
            align: 'left',
            editable: false,
        },
        {
            field: 'servicedescription',
            headerName: 'Descrição do Serviço',
            width: 500,
            type: 'string',
            align: 'left',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
        },
        {
            field: 'qtd',
            headerName: 'QTY',
            width: 90,
            type: 'number',
            align: 'center',
            editable: true,
        },
    ];



    const svlista = async () => {
        rowSelectionModel.forEach((poite) => {
            console.log(`posicao do item ${poite}`)
        });

        // Pega os dados das linhas selecionadas
        const selectedRowsData = rowSelectionModel.map((id) =>
            tarefas.find((row) => row.id === id)
        );

        const payload = {
            tarefas: selectedRowsData,
            sitename,
            sitenamefrom, 
            estado, 
            siteid
        };


        console.log('Linhas selecionadas:', payload);

 /*      api.post('v1/projetozte/tarefas', payload)
            .then(response => {
                if (response.status === 201) {
                    setmensagem('');
                    togglecadastro.bind(null)
                } else {
                    setmensagem(response.status);
                    setmensagemsucesso('');
                }
            })
            .catch(err => {
                if (err.response) {
                    setmensagem(err.response.data.erro);
                } else {
                    setmensagem('Ocorreu um erro na requisição.');
                }
                setmensagemsucesso('');
            });
*/













    }


    const iniciatabelas = () => {
        listatarefa();
    }

    useEffect(() => { iniciatabelas() }, []);
    return (
      <Modal
        isOpen={show}
        toggle={togglecadastro.bind(null)}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-xl modal-dialog-scrollable"
      >
        <ModalHeader toggle={togglecadastro.bind(null)}>{titulotopo}</ModalHeader>
        <ModalBody>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {mensagemsucesso.length > 0 ? (
            <div className="alert alert-success" role="alert">
              {' '}
              Registro Salvo
            </div>
          ) : null}

          {loading ? (
            <Loader />
          ) : (
            <>
              <Row>
                <Box sx={{ height: 350, width: '100%' }}>
                  <DataGrid
                    rows={tarefas}
                    columns={tarefascolunas}
                    loading={loading}
                    pageSize={pageSize}
                    onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                    disableSelectionOnClick
                    checkboxSelection
                    onRowSelectionModelChange={(newRowSelectionModel) => {
                      setRowSelectionModel(newRowSelectionModel);
                    }}
                    rowSelectionModel={rowSelectionModel}
                    processRowUpdate={handleProcessRowUpdate} // Atualiza os dados ao editar
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
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
              </Row>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="success" onClick={svlista} disabled={modoVisualizador()}>
            Salvar
          </Button>
          <Button color="secondary" onClick={togglecadastro.bind(null)}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>
    );
};

Zteedicaotarefa.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    ididentificador: PropTypes.number,
    atualiza: PropTypes.node,
    titulotopo: PropTypes.string,
    region: PropTypes.string,
    sitename: PropTypes.string,
    sitenamefrom: PropTypes.string, 
    estado: PropTypes.string,
    siteid: PropTypes.string,
};

export default Zteedicaotarefa;