import { useState, useEffect } from 'react';
import { Button, CardBody } from 'reactstrap';
import {
  Card,
  Typography,
  Grid,
  Box,
  CardContent,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Input,
  Checkbox,
  ListItemText,
} from '@mui/material';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
//import ComponentCard from '../../components/ComponentCard';
import Ericssoncontrolelpu from '../../components/formulario/projeto/Ericssoncontrolelpu';
import Ericssonfechamento from '../../components/formulario/projeto/Ericssonfechamento';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriototalacionamento from '../../components/formulario/relatorio/Relatoriototalacionamento';
import Relatoriofechamento from '../../components/formulario/relatorio/Relatoriofechamento';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';
import Huaweiacionamento from '../../components/formulario/projeto/Huaweiacionamento';
import api from '../../services/api';
import Rollouthuawei from '../rollout/Rollouthuawei';

export default function Clientehuawei() {
  const [telaacionamento, settelaacionamento] = useState('');
  const [telalpu, settelalpu] = useState('');
  const [telafechamento, settelafechamento] = useState('');
  const [telarelatorio, settelarelatorio] = useState('');
  const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
  const [telarelatorioacionamento, settelarelatorioacionamento] = useState('');
  const [telarelatoriofechamento, settelarelatoriofechamento] = useState('');
  const [valueDashboard, setValueDashboard] = useState({});
  const [optionsregional, setoptionsregional] = useState([]);
  const [year, setYear] = useState('2025');
  const [site, setSite] = useState('');
  const [optionsregionalselected, setoptionsregionalselected] = useState(['Todos']);
  const currentYear = new Date().getFullYear();
  const years = Array.from({ length: 10 }, (_, i) => currentYear - i);
  const [telarollouthuawei, settelarollouthuawei] = useState(false);

  function acionamento() {
    settelaacionamento(true);
  }

  function fechamento() {
    settelafechamento(true);
  }

  function relacionamento() {
    settelarelatorioacionamento(true);
  }
  function relfechamento() {
    settelarelatoriofechamento(true);
  }

  function rollouthuawei() {
    settelarollouthuawei(true);
  }

  function limparFiltros() {}

  const handleFilteroptionsregionalselectedChange = (event) => {
    const {
      target: { value },
    } = event;

    let selectedValues = typeof value === 'string' ? value.split(',') : value;

    if (optionsregionalselected.includes('Todos')) {
      selectedValues = selectedValues.filter((v) => v !== 'Todos');
    }

    if (selectedValues.includes('Todos')) {
      setoptionsregionalselected(['Todos']);
      return;
    }

    setoptionsregionalselected(selectedValues);
  };

  const loadingoptionsregional = async () => {
    try {
      const response = await api.get('v1/projetohuawei/regionalhuawei');
      setoptionsregional(response.data);
    } catch (err) {
      console.error(err.message);
    }
  };

  const painelcontrole = async () => {
    try {
      const response = await api.get('v1/painelcontrole', {
        params: {
          ano: year,
          site,
          regional: Array.isArray(optionsregionalselected) ? optionsregionalselected.join(',') : '',
        },
      });
      const { data } = response;
      setValueDashboard(data);
    } catch (error) {
      console.error('Erro ao obter valor de recebimento:', error.message);
    }
  };

  const iniciatabelas = async () => {
    await Promise.all([painelcontrole()]);
  };

  const filtertabelas = async () => {
    await Promise.all([painelcontrole()]);
  };

  useEffect(() => {
    iniciatabelas();
    loadingoptionsregional();
  }, []);

  useEffect(() => {
    filtertabelas();
  }, [year, site, optionsregionalselected]);

  return (
    <div className="col-sm-12">
      {telaacionamento ? (
        <>
          <Huaweiacionamento show={telaacionamento} setshow={settelaacionamento} />
        </>
      ) : null}

      {telalpu ? (
        <>
          <Ericssoncontrolelpu show={telalpu} setshow={settelalpu} />
        </>
      ) : null}

      {telafechamento ? (
        <>
          <Ericssonfechamento show={telafechamento} setshow={settelafechamento} />
        </>
      ) : null}

      {telarelatorio ? (
        <>
          <Relatoriopoxfaturado show={telarelatorio} setshow={settelarelatorio} />
        </>
      ) : null}
      {telarelatoriodespesa ? (
        <>
          <Relatoriodespesa show={telarelatoriodespesa} setshow={settelarelatoriodespesa} />
        </>
      ) : null}

      {telarelatorioacionamento ? (
        <>
          <Relatoriototalacionamento
            show={telarelatorioacionamento}
            setshow={settelarelatorioacionamento}
          />
        </>
      ) : null}
      {telarelatoriofechamento ? (
        <>
          <Relatoriofechamento
            show={telarelatoriofechamento}
            setshow={settelarelatoriofechamento}
          />
        </>
      ) : null}
      {telarollouthuawei && (
        <Rollouthuawei show={telarollouthuawei} setshow={settelarollouthuawei} />
      )}

      <BreadCrumbs />

      <Card>
        <CardContent style={{ backgroundColor: 'white' }}>
          <Box p={2}>
            <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
              <Typography variant="h5">Rollout Dashboard</Typography>
            </Box>

            <Box display="flex" gap={2} flexWrap="wrap" mb={3}>
              <Button variant="contained" onClick={limparFiltros}>
                Limpar Filtros
              </Button>

              <FormControl size="small">
                <InputLabel id="ano-label">Ano</InputLabel>
                <Select
                  labelId="ano-label"
                  value={year}
                  onChange={(e) => setYear(e.target.value)}
                  label="Ano"
                >
                  {years.map((yr) => (
                    <MenuItem key={yr} value={yr.toString()}>
                      {yr}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
              <FormControl>
                <InputLabel id="site">Site</InputLabel>
                <Input
                  id="site"
                  aria-describedby="site"
                  value={site}
                  onChange={(e) => setSite(e.target.value)}
                />
              </FormControl>

              <FormControl size="small">
                <InputLabel id="regional">Regional</InputLabel>
                <Select
                  labelId="regional"
                  value={optionsregionalselected}
                  onChange={handleFilteroptionsregionalselectedChange}
                  label="Regional"
                  size="small"
                  renderValue={(selected) => {
                    if (selected.includes('Todos')) return 'Todos';
                    if (selected.length === 1) return selected;
                    return `${selected.length} selecionado(s)`;
                  }}
                  sx={{ width: 100 }}
                >
                  <MenuItem value="Todos">
                    <Checkbox checked={optionsregionalselected.includes('Todos')} />
                    <ListItemText primary="Todos" />
                  </MenuItem>
                  {optionsregional.map((option) => (
                    <MenuItem key={option} value={option}>
                      <Checkbox checked={optionsregionalselected.includes(option)} />
                      <ListItemText primary={option} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

              <Grid container spacing={2}>
                {[
                  {
                    titulo: 'MOS',
                    dados: [
                      {
                        label: 'Total',
                        value: valueDashboard.totalMos,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Concluído',
                        value: valueDashboard.mosConcluido,
                        color: 'green',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Em Andamento',
                        value: valueDashboard.mosAndamento,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Atrasada',
                        value: valueDashboard.mosAtrasado,
                        color: '#d32f2f',
                        bg: '#fff5f5',
                      },
                    ],
                  },
                  {
                    titulo: 'INSTALAÇÃO',
                    dados: [
                      {
                        label: 'Total',
                        value: valueDashboard.totalInstalacao,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Concluído',
                        value: valueDashboard.instalacaoConcluida,
                        color: 'green',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Em Andamento',
                        value: valueDashboard.instalacaoAndamento,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Atrasada',
                        value: valueDashboard.instalacaoAtrasado,
                        color: '#d32f2f',
                        bg: '#fff5f5',
                      },
                    ],
                  },
                  {
                    titulo: 'VALIDAÇÃO',
                    dados: [
                      {
                        label: 'Total',
                        value: valueDashboard.totalValidacao,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Concluído',
                        value: valueDashboard.validacaoConcluida,
                        color: 'green',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Em Andamento',
                        value: valueDashboard.validacaoAndamento,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Atrasada',
                        value: valueDashboard.validacaoAtrasado,
                        color: '#d32f2f',
                        bg: '#fff5f5',
                      },
                    ],
                  },
                  {
                    titulo: 'INTEGRAÇÃO',
                    dados: [
                      {
                        label: 'Total',
                        value: valueDashboard.totalIntegracao,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Concluído',
                        value: valueDashboard.integracaoConcluida,
                        color: 'green',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Em Andamento',
                        value: valueDashboard.integracaoAndamento,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Atrasada',
                        value: valueDashboard.integracaoAtrasado,
                        color: '#d32f2f',
                        bg: '#fff5f5',
                      },
                    ],
                  },
                  {
                    titulo: 'DOCUMENTAÇÃO',
                    dados: [
                      {
                        label: 'Total',
                        value: valueDashboard.totalDocumentacao,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Concluído',
                        value: valueDashboard.documentacaoConcluida,
                        color: 'green',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Em Andamento',
                        value: valueDashboard.documentacaoAndamento,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Atrasada',
                        value: valueDashboard.documentacaoAtrasado,
                        color: '#d32f2f',
                        bg: '#fff5f5',
                      },
                    ],
                  },
                  {
                    titulo: 'ACEITAÇÃO',
                    dados: [
                      {
                        label: 'Total',
                        value: valueDashboard.totalAceitacao,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Concluído',
                        value: valueDashboard.aceitacaoConcluida,
                        color: 'green',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Em Andamento',
                        value: valueDashboard.aceitacaoAndamento,
                        color: '#001f3f',
                        bg: '#f5f5f5',
                      },
                      {
                        label: 'Atrasada',
                        value: valueDashboard.aceitacaoAtrasado,
                        color: '#d32f2f',
                        bg: '#fff5f5',
                      },
                    ],
                  },
                ].map(({ titulo, dados }) => (
                  <Grid item xs={12} sm={6} md={2} key={titulo}>
                    {dados.map(({ label, value, color, bg }) => (
                      <Card key={label} sx={{ backgroundColor: bg, mb: 1, height: 110 }}>
                        <CardContent>
                          <Typography
                            variant="h5"
                            align="center"
                            sx={{ color, fontWeight: 'bold' }}
                          >
                            {value}
                          </Typography>
                          <Typography variant="body2" align="center">
                            {`${titulo} ${label}`}
                          </Typography>
                        </CardContent>
                      </Card>
                    ))}
                  </Grid>
                ))}
              </Grid>
              <br></br>
            </Box>
          </Box>
        </CardContent>

        <Box p={2}>
          <Typography variant="h6">Opções</Typography>
          <CardBody style={{ backgroundColor: 'white' }}>
            <br></br>
            <Button color="link" onClick={() => rollouthuawei()}>
              Rollout
            </Button>
            <br></br>
            <Button color="link" onClick={() => acionamento()}>
              Acionamento
            </Button>
            <br></br>
            <Button color="link" onClick={() => fechamento()}>
              Fechamento
            </Button>
          </CardBody>
        </Box>

        <Box p={2}>
          <Typography variant="h6">Relatórios</Typography>
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => relacionamento()}>
              Total de Acionamentos
            </Button>
            <br></br>
            <Button color="link">Previsão de Fechamento</Button>
            <br></br>
            <Button color="link" onClick={() => relfechamento()}>
              Historico de Fechamento
            </Button>
          </CardBody>
        </Box>
      </Card>
    </div>
  );
}
