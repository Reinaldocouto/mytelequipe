import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Box } from '@mui/material';
import Typography from '@mui/material/Typography';
import {
  Col,
  Button,
  FormGroup,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import Select from 'react-select';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import S3Service from '../../../services/s3Service';
import modoVisualizador from '../../../services/modovisualizador';

let s3Service;

const fetchS3Credentials = async () => {
  try {
    const response = await api.get('v1/credenciaiss3');
    if (response.status === 200) {
      const { acesskeyid, secretkey, region, bucketname } = response?.data[0];
      s3Service = new S3Service({
        region,
        accessKeyId: acesskeyid,
        secretAccessKey: secretkey,
        bucketName: bucketname,
      });
    } else {
      console.error('Credenciais do S3 não encontradas ou resposta malformada:', response.data);
    }
  } catch (error) {
    console.error('Erro ao buscar credenciais do S3:', error);
  }
};

function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

const Despesasedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [empresalista, setempresalista] = useState([]);
  const [veiculoslista, setveiculoslista] = useState([]);
  const [iddespesas, setiddespesas] = useState();
  const [datalancamento, setdatalancamento] = useState(() => {
    const ontem = new Date();
    ontem.setDate(ontem.getDate());
    return ontem.toISOString().split('T')[0];
  });
  const [valordespesa, setvalordespesa] = useState();
  const [descricao, setdescricao] = useState();
  const [comprovante, setcomprovante] = useState();
  const [observacao, setobservacao] = useState();
  const [idempresa, setidempresa] = useState();
  const [idveiculo, setidveiculo] = useState();
  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);
  const [selectedoptionveiculo, setselectedoptionveiculo] = useState(null);
  const [funcionariolista, setfuncionariolista] = useState([]);
  const [selectedoptionfuncionario, setselectedoptionfuncionario] = useState(null);
  const [idpessoa, setidpessoa] = useState('');
  const [file, setFile] = useState(null);
  const [uploadedFiles, setUploadedFiles] = useState([]);
  const [periodicidade, setPeriodicidade] = useState('');
  const [categoriaDespesa, setCategoriaDespesa] = useState('');
  const [parceladoEm, setParceladoEm] = useState('');
  const [valordaparcela, setvalordaparcela] = useState('');
  const [dataInicio, setDataInicio] = useState('');
  //const [periodo, setPeriodo] = useState('');

  const params = {
    idcliente: 1,
    idusuario: 1,
    idloja: 1,
    idpessoabusca: ididentificador,
    deletado: 0,
  };

  const togglecadastro = () => {
    setshow(false);
  };
  const validarCampos = () => {
    if (!datalancamento) {
      const ontem = new Date();
      ontem.setDate(ontem.getDate());
      setdatalancamento(ontem.toISOString().split('T')[0]);
    }

    if (!valordespesa) {
      setmensagem("O campo 'Valor da Despesa' é obrigatório.");
      return false;
    }

    if (!idveiculo) {
      setmensagem("O campo 'Veículo' é obrigatório.");
      return false;
    }

    if (!categoriaDespesa) {
      setmensagem("O campo 'Categoria da Despesa' é obrigatório.");
      return false;
    }

    if (!periodicidade) {
      setmensagem("O campo 'Periodicidade' é obrigatório.");
      return false;
    }

    if (periodicidade !== 'Unica') {
      if (!parceladoEm) {
        setmensagem("O campo 'Parcelado em' é obrigatório.");
        return false;
      }
      if (!valordaparcela) {
        setmensagem("O campo 'Valor da Parcela' é obrigatório para despesas parceladas.");
        return false;
      }

      if (parceladoEm < 2) {
        setmensagem('O número de parcelas deve ser 2 ou mais.');
        return false;
      }
    }

    return true;
  };
  function moedaParaNumero(valorFormatado) {
    if (!valorFormatado) return 0;

    // Remove o "R$", pontos (milhar) e espaços
    let valorLimpo = valorFormatado.replace(/[R$\s\\.]/g, '');

    // Troca vírgula decimal por ponto decimal
    valorLimpo = valorLimpo.replace(',', '.');

    // Converte para número float
    const valorNumerico = parseFloat(valorLimpo);

    return Number.isNaN(valorNumerico) ? 0 : valorNumerico;
  }
  const listafuncionario = async (id) => {
    try {
      setloading(true);
      await api.get(`v1/pessoa/selectfuncionario/${id}`).then((response) => {
        //console.log("get de funcionarios: ", response.data);
        setfuncionariolista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function ProcessaCadastro(e) {
    e.preventDefault();
    const ontem = new Date();
    ontem.setDate(ontem.getDate());
    const dataNow = ontem.toISOString().split('T')[0];

    if (!validarCampos()) return;
    const valorTotalColadaPeloUsuario =
      Math.round(parceladoEm * Number(valordaparcela.replace(',', '.')) * 100) / 100;
    const valorTotalNumerico = Math.round(Number(valordespesa.replace(',', '.')) * 100) / 100;

    if (valorTotalNumerico !== valorTotalColadaPeloUsuario) {
      setmensagem(
        'Valor da parcela multiplicado pelo número de parcelas não é igual ao valor total.',
      );
    }
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/despesas', {
        iddespesas: ididentificador,
        datalancamento: datalancamento ?? dataNow,
        valordespesa,
        descricao,
        comprovante,
        observacao,
        idveiculo,
        //periodo,
        dataInicio,
        valordaparcela: moedaParaNumero(valordaparcela),
        parceladoEm,
        categoria: categoriaDespesa,
        periodicidade,
        idempresa,
        idpessoa,
        despesacadastradapor: localStorage.getItem('sessionNome'),
        idcliente: 1,
        idusuario: 1,
        idloja: 1,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setTimeout(() => {
            setshow(!show);
            atualiza();
          }, 1000);

          togglecadastro.bind(null);
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  const listFilesFromS3 = async () => {
    try {
      const prefix = `despesas/${iddespesas}/`;
      const files = await s3Service.listFiles(prefix);
      const fileUrls = await Promise.all(
        files.map(async (filee) => {
          const url = await s3Service.getFileUrl(filee.Key);
          return { name: filee.Key.split('/').pop(), url, key: filee.Key };
        }),
      );
      setUploadedFiles(fileUrls);
    } catch (error) {
      console.error('Failed to list files', error);
    }
  };

  const listadespesas = async () => {
    try {
      setloading(true);
      await api.get('v1/despesasid', { params }).then((response) => {
        //console.log("get de despesas por id: ", response.data);
        setiddespesas(response.data.iddespesas);
        setdatalancamento(response.data.datalancamento);
        setvalordespesa(response.data.valordespesa);
        setdescricao(response.data.descricao);
        setcomprovante(response.data.comprovante);
        setobservacao(response.data.observacao);
        setselectedoptionempresa({ value: response.data.idempresa, label: response.data.empresa });
        setselectedoptionveiculo({ value: response.data.idveiculo, label: response.data.veiculo });
        setidempresa(response.data.idempresa);
        if (response.data.idempresa) listafuncionario(response.data.idempresa);
        setidveiculo(response.data.idveiculo);
        setvalordaparcela(response.data.valorparcela);
        //setPeriodo(response.data.periodo);
        setParceladoEm(response.data.parceladoem);
        setPeriodicidade(response.data.periodicidade);
        setDataInicio(response.data.datainicio);
        setCategoriaDespesa(response.data.categoria);
        setidpessoa(response.data.idpessoa);
        setmensagem('');
        listFilesFromS3();
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaempresa = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj', { params }).then((response) => {
        //console.log("get de empresas: ", response.data);
        setempresalista(response.data ?? null);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaveiculos = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/veiculos', { params });
      //console.log("get de veiculos: ", response.data);
      const lista = response.data.map((item) => {
        return {
          value: item.id,
          label: item.placa,
          empresaId: item.idempresa,
          pessoaId: item.idpessoa,
        };
      });
      setveiculoslista(lista);
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const iniciatabelas = () => {
    listaempresa();
    listaveiculos();
    listadespesas();
  };

  useEffect(() => {
    if (iddespesas) {
      listFilesFromS3();
    }
  }, [iddespesas]);

  useEffect(() => {
    const initializeS3Service = async () => {
      await fetchS3Credentials();
      iniciatabelas();
    };
    const ontem = new Date();
    ontem.setDate(ontem.getDate());
    const data = ontem.toISOString().split('T')[0];
    setdatalancamento(data);
    initializeS3Service();
  }, []);

  useEffect(() => {
    if (idempresa && empresalista && empresalista.length > 0) {
      const empresaSelecionada = empresalista.find((e) => e.value === idempresa);
      if (empresaSelecionada) {
        setselectedoptionempresa(empresaSelecionada);
      } else {
        setselectedoptionempresa(null);
      }
    }
  }, [idempresa, empresalista]);

  useEffect(() => {
    if (idpessoa && funcionariolista && funcionariolista.length > 0) {
      const funcionarioSelecionado = funcionariolista.find((f) => f.value === idpessoa);
      if (funcionarioSelecionado) {
        setselectedoptionfuncionario(funcionarioSelecionado);
      } else {
        setselectedoptionfuncionario(null);
      }
    }
  }, [funcionariolista, idpessoa]);

  const handlefuncionario = (stat) => {
    if (stat !== null) {
      setidpessoa(stat.value);
      setselectedoptionfuncionario({ value: stat.value, label: stat.label });
    } else {
      setidpessoa(0);
      setselectedoptionfuncionario({ value: null, label: null });
    }
  };

  const handleempresa = (stat) => {
    if (stat !== null) {
      setidempresa(stat.value);
      setselectedoptionempresa({ value: stat.value, label: stat.label });
      listafuncionario(stat.value);
    } else {
      setidempresa(0);
      setselectedoptionempresa({ value: null, label: null });
    }
  };

  const handleveiculo = (stat) => {
    if (stat !== null) {
      setidveiculo(stat.value);

      if (stat.empresaId) {
        setidempresa(stat.empresaId);
        listafuncionario(stat.empresaId);

        if (stat.pessoaId) {
          setidpessoa(stat.pessoaId);
        } else {
          setidpessoa(null);
          setselectedoptionfuncionario(null);
        }
      } else {
        setidempresa(null);
        setselectedoptionempresa(null);
        setidpessoa(null);
        setselectedoptionfuncionario(null);
      }

      setselectedoptionveiculo({ value: stat.value, label: stat.label });
    } else {
      setidveiculo(0);
      setselectedoptionveiculo(null);
      setidempresa(null);
      setselectedoptionempresa(null);
      setidpessoa(null);
      setselectedoptionfuncionario(null);
    }
  };

  const handleFileUpload = async () => {
    if (file) {
      try {
        const key = `despesas/${ididentificador}/${file.name}`; // Colocando o arquivo na pasta da despesa específica
        await s3Service.uploadFile(file, key);
        const url = await s3Service.getFileUrl(key);
        setUploadedFiles([...uploadedFiles, { name: file.name, url }]);
      } catch (error) {
        console.error('File upload failed', error);
      }
    }
  };

  const handleDeleteFile = async (fileKey) => {
    try {
      await s3Service.deleteFile(fileKey);
      setUploadedFiles(uploadedFiles.filter((uploadedFile) => uploadedFile.key !== fileKey));
    } catch (error) {
      console.error('File deletion failed', error);
    }
  };

  const handleGenerateDownloadLink = async (fileName) => {
    try {
      const key = `despesas/${ididentificador}/${fileName}`;
      const url = await s3Service.getFileUrl(key);

      if (!url) {
        throw new Error('URL não gerado corretamente');
      }

      // Cria um link temporário para download
      const link = document.createElement('a');
      link.href = url;
      link.download = fileName; // Força o download
      link.style.display = 'none';
      document.body.appendChild(link);
      link.click();

      // Remove o link após o clique
      document.body.removeChild(link);
    } catch (error) {
      console.error('Falha ao gerar o link de download', error);
    }
  };

  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-fullscreen "
    >
      <ModalHeader style={{ backgroundColor: 'white' }} toggle={togglecadastro.bind(null)}>
        Cadastro de Despesas
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
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
            <div className="row g-3">
              <Col md="3">
                <FormGroup>
                  <Input
                    type="hidden"
                    onChange={(e) => setiddespesas(e.target.value)}
                    value={iddespesas}
                    placeholder=""
                  />
                  Data do Lançamento
                  <Input
                    type="date"
                    onChange={(e) => setdatalancamento(e.target.value)}
                    value={datalancamento}
                    placeholder=""
                    min="2022-12-01"
                    defaultValue={(() => {
                      const ontem = new Date();
                      ontem.setDate(ontem.getDate() - 1);
                      const data = ontem.toISOString().split('T')[0];
                      return data;
                    })()}
                  />
                </FormGroup>
              </Col>
              <div className="col-sm-3">
                Veiculo
                <Select
                  isClearable
                  isSearchable
                  name="veiculo"
                  options={veiculoslista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleveiculo}
                  value={selectedoptionveiculo}
                />
              </div>
              <div className="col-sm-3">
                Empresa
                <Select
                  isClearable
                  isSearchable
                  name="empresa"
                  options={empresalista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleempresa}
                  value={selectedoptionempresa}
                />
              </div>
              <div className="col-sm-3">
                Funcionário
                <Select
                  isClearable
                  isSearchable
                  name="funcionario"
                  options={funcionariolista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handlefuncionario}
                  value={selectedoptionfuncionario}
                />
              </div>
              <Col md="3">
                <FormGroup>
                  Categoria
                  <Input
                    type="select"
                    onChange={(e) => setCategoriaDespesa(e.target.value)}
                    value={categoriaDespesa}
                  >
                    <option value="">Selecione</option>
                    <option value="Combustível">COMBUSTÍVEL</option>
                    <option value="Locação">LOCAÇÃO</option>
                    <option value="Manutenção">MANUTENÇÃO</option>
                    <option value="Pedágio">PEDÁGIO</option>
                    <option value="Outros">OUTROS</option>
                  </Input>
                </FormGroup>
              </Col>
              {/* <Col md="3">
                <FormGroup>
                  Período
                  <Input
                    type="text"
                    onChange={(e) => setPeriodo(e.target.value)}
                    value={periodo}
                    placeholder="Ex: 01/2025"
                  />
                </FormGroup>
              </Col> */}
              <Col md="3">
                <FormGroup>
                  Periodicidade
                  <Input
                    type="select"
                    onChange={(e) => {
                      if (e.target.value === 'Unica') {
                        setParceladoEm('1');
                        setvalordaparcela(valordespesa);
                      } else {
                        setParceladoEm('2');
                        setvalordaparcela('');
                      }
                      setPeriodicidade(e.target.value);
                    }}
                    value={periodicidade}
                  >
                    <option value="">Selecione</option>
                    <option value="Unica">Unica</option>
                    <option value="Mensal">MENSAL</option>
                    <option value="Bimestral">BIMESTRAL</option>
                    <option value="Trimestral">TRIMESTRAL</option>
                    <option value="Anual">ANUAL</option>
                  </Input>
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Parcelado em
                  <Input
                    type="number"
                    min={1}
                    disabled={periodicidade === 'Unica'}
                    onChange={(e) => {
                      if (valordaparcela) {
                        const value = e.target.value * valordaparcela;
                        setvalordespesa(value.toFixed(2));
                      }
                      setParceladoEm(e.target.value);
                    }}
                    value={parceladoEm}
                  ></Input>
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Valor da parcela
                  <Input
                    type="text"
                    onChange={(e) => {
                      const input = e.target.value;
                      //disabled={periodicidade === 'Unica'}
                      //const numeros = input.replace(/\D/g, '');
                      //const valor = numeros ? parseFloat(numeros) / 100 : 0;
                      const value = e.target.value.replace(',', '.') * parceladoEm;
                      setvalordespesa(value.toFixed(2));
                      setvalordaparcela(input);
                      // setvalordaparcela(
                      //   valor.toLocaleString('pt-BR', {
                      //     style: 'currency',
                      //     currency: 'BRL',
                      //   }),
                      // );
                    }}
                    value={valordaparcela}
                    placeholder="Ex: 100,10"
                  />
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Data do inicio do pagamento
                  <Input
                    type="date"
                    onChange={(e) => setDataInicio(e.target.value)}
                    value={dataInicio}
                  ></Input>
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Valor Total
                  <Input
                    type="text"
                    disabled
                    // onChange={(e) => {
                    //   console.log(e);
                    //   //const input = e.target.value;
                    //   // //const numeros = input.replace(/\D/g, '');
                    //   // if (periodicidade === 'Unica') {
                    //   //   setParceladoEm('1');
                    //   //   setvalordaparcela(e.target.value);
                    //   // }
                    //   // //const valor = numeros ? parseFloat(numeros) / 100 : 0;
                    //   // setvalordespesa(input);
                    // }}
                    value={valordespesa}
                    placeholder="R$ 0,00"
                  />
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Descrição da Despesa
                  <Input
                    type="text"
                    onChange={(e) => setdescricao(e.target.value)}
                    value={descricao}
                    placeholder=""
                  />
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Comprovante
                  <Input
                    type="text"
                    onChange={(e) => setcomprovante(e.target.value)}
                    value={comprovante}
                    placeholder="Comprovante"
                  />
                </FormGroup>
              </Col>
            </div>
            <div className="row g-3">
              <FormGroup>
                Observação
                <Input
                  className="form-control"
                  type="textarea"
                  name="observacao"
                  id="observacao"
                  onChange={(e) => setobservacao(e.target.value)}
                  value={observacao}
                />
              </FormGroup>
            </div>
            <div className="row g-3">
              <Col md="6">
                <FormGroup>
                  <div className="d-flex align-items-center">
                    <Input type="file" onChange={(e) => setFile(e.target.files[0])} />
                    <Button color="primary" onClick={handleFileUpload} className="ms-0">
                      Upload
                    </Button>
                  </div>
                </FormGroup>
              </Col>
            </div>
            <div style={{ backgroundColor: 'white' }}>
              <div className="col-sm-12">
                <div className="d-flex flex-row-reverse custom-file">
                  <table className="table table-white-bg">
                    <thead>
                      <tr>
                        <th>Nome do arquivo</th>
                        <th>Download</th>
                        <th>Delete</th>
                      </tr>
                    </thead>
                    <tbody>
                      {uploadedFiles.map((uploadedFile) => (
                        <tr key={uploadedFile.name}>
                          <td>{uploadedFile.name}</td>
                          <td>
                            <Button
                              color="primary"
                              onClick={() => handleGenerateDownloadLink(uploadedFile.name)}
                            >
                              Download
                            </Button>
                          </td>
                          <td>
                            <Button
                              color="danger"
                              onClick={() => handleDeleteFile(uploadedFile.key)}
                            >
                              Delete
                            </Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Despesasedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.func,
};

export default Despesasedicao;
