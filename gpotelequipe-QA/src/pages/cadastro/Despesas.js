import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import * as Icon from 'react-feather';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
// import SearchIcon from '@mui/icons-material/Search';
//import FileCopyIcon from '@mui/icons-material/FileCopy';
//import SecurityIcon from '@mui/icons-material/Security';
//  import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import Excluirregistro from '../../components/Excluirregistro';
import exportExcel from '../../data/exportexcel/Excelexport';
import Despesasedicao from '../../components/formulario/cadastro/Despesasedicao';
import Notpermission from '../../layouts/notpermission/notpermission';
import modoVisualizador from '../../services/modovisualizador';

export default function Despesas() {
  const [despesas, setdespesas] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [titulo, settitulo] = useState('');
  const [arquivodespesa, setarquivodespesa] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [permission, setpermission] = useState(0);
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
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  const listadespesas = async () => {
    try {
      setloading(true);
      await api.get('/v1/despesas', { params }).then((response) => {
        setdespesas(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function alterarDespesa(stat) {
    console.log(titulo);
    settitulo('Editar Despesas');
    settelacadastroedicao(true);
    setididentificador(stat);
    listadespesas();
  }
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.despesas === 1);
  }
  function deleteUser(stat) {
    setididentificador(stat);
    settelaexclusao(true);
    listadespesas();
  }

  /*
  function toggleAdmin() { }

  function duplicateUser() { }
  */

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 90,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          hint="Alterar"
          onClick={() => alterarDespesa(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
        /*
        <GridActionsCellItem
          icon={<SecurityIcon />}
          label="Verificar Histórico"
          onClick={() => toggleAdmin(parametros.id)}
          showInMenu
        />,
        <GridActionsCellItem
          icon={<FileCopyIcon />}
          label="Indicar Usuário"
          onClick={() => duplicateUser(parametros.id)}
          showInMenu
        />,
        */
      ],
    },
    //  { field: 'id', headerName: 'ID', width: 60, align: 'center', },
    {
      field: 'placa',
      headerName: 'Placa',
      type: 'string',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'datalancamento',
      headerName: 'Data Lançamento',
      type: 'string',
      width: 140,
      align: 'center',
      editable: false,
    },
    {
      field: 'datainicio',
      headerName: 'Data Inicio do pagamento',
      type: 'string',
      width: 140,
      align: 'center',
      editable: false,
    },
    {
      field: 'despesacadastradapor',
      headerName: 'Cadastrado por',
      type: 'string',
      width: 140,
      align: 'center',
      editable: false,
    },
    {
      field: 'datadocadastro',
      headerName: 'Data Cadastro',
      type: 'string',
      width: 140,
      align: 'center',
      editable: false,
    },
    {
      field: 'periodicidade',
      headerName: 'Periodicidade',
      type: 'string',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'parceladoem',
      headerName: 'Parcelado em',
      type: 'string',
      width: 140,
      align: 'center',
      editable: false,
    },
    {
      field: 'valorparcela',
      headerName: 'Valor da parcela',
      type: 'string',
      width: 140,
      align: 'center',
      editable: false,
    },
    {
      field: 'valordespesa',
      headerName: 'Valor total',
      width: 120,
      align: 'center',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      type: 'string',
      width: 180,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'comprovante',
      headerName: 'Comprovante',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'empresa',
      headerName: 'Empresa',
      type: 'string',
      width: 350,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'veiculo',
      headerName: 'Veículos',
      type: 'string',
      width: 200,
      align: 'rigth',
      editable: false,
    },
    /*
    {
      field: 'observacao',
      headerName: 'Observação',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    */
  ];

  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivodespesa) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const formData = new FormData();
    formData.append('files', arquivodespesa);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/uploaddespesas', formData, header);
      if (response && response.data) {
        if (response.status === 200) {
          setmensagemsucesso(
            'Upload concluido, aguarde a atualização que dura em torno de 20 minutos',
          );
          listadespesas();
          setmensagem('');
        } else {
          setmensagemsucesso('');
          setmensagem('Erro ao fazer upload!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        setmensagem(err.message);
        setmensagemsucesso('');
      } else {
        setmensagem('Erro: Tente novamente mais tarde!');
        setmensagemsucesso('');
      }
    } finally {
      setloading(false);
    }
  };

  const novocadastro = () => {
    //settelacadastro(true);
    api
      .post('v1/despesas/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
          settitulo('Cadastro de Despesas');
          settelacadastro(true);
        } else {
          setmensagem(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  const gerarexcel = () => {
    const excelData = despesas.map((item) => {
      return {
        'Data Lançamento': item.datalancamento,
        'Data Cadastro': item.datadocadastro,
        'Valor Despesa': item.valordespesa,
        'Data Início': item.datainicio,
        Periodicidade: item.periodicidade,
        Descrição: item.descricao,
        Comprovante: item.comprovante,
        Empresa: item.empresa,
        Veículo: item.veiculo,
        Placa: item.placa,
        Funcionário: item.funcionario,
        Categoria: item.categoria,
        'Parcelado em': item.parceladoem,
        'Valor da Parcela': item.valorparcela,
        Observação: item.observacao,
        'Despesa Cadastrada Por': item.despesacadastradapor,
      };
    });
    exportExcel({ excelData, fileName: 'despesas' });
  };

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

  useEffect(() => {
    listadespesas();
    userpermission();
  }, []);

  return (
    <div>
      {' '}
      {permission && (
        <Card>
          <CardBody className="bg-light">
            <CardTitle tag="h4" className="mb-0">
              Despesas
            </CardTitle>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
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
            <div className="row g-3">
              <div className="col-sm-6">
                Selecione o arquivo de atualização
                <div className="d-flex flex-row-reverse custom-file">
                  <InputGroup>
                    <Input
                      type="file"
                      onChange={(e) => setarquivodespesa(e.target.files[0])}
                      disabled={modoVisualizador()}
                      className="custom-file-input"
                      id="customFile3"
                    />
                    <Button color="primary" onClick={uploadarquivo} disabled={modoVisualizador()}>
                      Atualizar{' '}
                    </Button>
                  </InputGroup>
                </div>
              </div>

              <div className=" col-sm-6  d-flex flex-row-reverse">
                <Button
                  color="primary"
                  onClick={() => novocadastro()}
                  disabled={modoVisualizador()}
                  s
                >
                  Adicionar <Icon.Plus />
                </Button>
                {telacadastro ? (
                  <>
                    <Despesasedicao
                      show={telacadastro}
                      setshow={settelacadastro}
                      ididentificador={ididentificador}
                      atualiza={listadespesas}
                      titulotopo={titulo}
                    />
                  </>
                ) : null}
                {telacadastroedicao ? (
                  <>
                    {' '}
                    <Despesasedicao
                      show={telacadastroedicao}
                      setshow={settelacadastroedicao}
                      ididentificador={ididentificador}
                      atualiza={listadespesas}
                      titulotopo={titulo}
                    />{' '}
                  </>
                ) : null}
                {telaexclusao ? (
                  <>
                    <Excluirregistro
                      show={telaexclusao}
                      setshow={settelaexclusao}
                      ididentificador={ididentificador}
                      quemchamou="DESPESAS"
                      atualiza={listadespesas}
                    />{' '}
                  </>
                ) : null}
              </div>
            </div>
          </CardBody>
          {/**tabela*/}
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => gerarexcel()}>
              {' '}
              Exportar Excel
            </Button>
            <Box sx={{ height: despesas.length > 0 ? '100%' : 500, width: '100%' }}>
              <DataGrid
                rows={despesas}
                columns={columns}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                experimentalFeatures={{ newEditingApi: true }}
                components={{
                  NoRowsOverlay: CustomNoRowsOverlay,
                  Pagination: CustomPagination,
                  LoadingOverlay: LinearProgress,
                }}
              />
            </Box>
          </CardBody>
        </Card>
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
