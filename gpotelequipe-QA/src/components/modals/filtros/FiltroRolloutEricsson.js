import {
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  FormGroup,
  Label,
  Input,
} from 'reactstrap';
import SettingsIcon from '@mui/icons-material/Settings';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import PropTypes from 'prop-types';
import ClearIcon from '@mui/icons-material/Clear';

const FiltroRolloutEricsson = ({
  show1,
  toggle1,
  toggleConfigModal,
  fieldVisibility,
  formValues,
  setFormValues,
  limparFiltro,
  aplicarFiltro,
}) => {
  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormValues((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }));
  };
  return (
    <Modal
      isOpen={show1}
      toggle={toggle1}
      className="modal-dialog modal-lg modal-dialog-scrollable"
      backdrop="static"
      keyboard={false}
    >
      <ModalHeader toggle={toggle1}>
        Filtro
        <Button color="link" onClick={toggleConfigModal} className="float-end">
          <SettingsIcon /> Configurar Campos
        </Button>
      </ModalHeader>
      <ModalBody style={{ maxHeight: '70vh', overflowY: 'auto' }}>
        <div>
          {/* Campos que você já tinha */}
          {fieldVisibility.rfp && (
            <FormGroup>
              <Label for="rfp" className="fw-bold">
                RFP
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o RFP"
                id="rfp"
                name="rfp"
                value={formValues.rfp || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.numero && (
            <FormGroup>
              <Label for="numero" className="fw-bold">
                NÚMERO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o Número"
                id="numero"
                name="numero"
                value={formValues.numero || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.cliente && (
            <FormGroup>
              <Label for="cliente" className="fw-bold">
                CLIENTE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o Cliente"
                id="cliente"
                name="cliente"
                value={formValues.cliente || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.regional && (
            <FormGroup>
              <Label for="regional" className="fw-bold">
                REGIONAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite a Regional"
                id="regional"
                name="regional"
                value={formValues.regional || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.site && (
            <FormGroup>
              <Label for="site" className="fw-bold">
                SITE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o Site"
                id="site"
                name="site"
                value={formValues.site || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.fornecedor && (
            <FormGroup>
              <Label for="fornecedor" className="fw-bold">
                FORNECEDOR
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o Fornecedor"
                id="fornecedor"
                name="fornecedor"
                value={formValues.fornecedor || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.situacaoimplantacao && (
            <FormGroup>
              <Label for="situacaoimplantacao" className="fw-bold">
                SITUAÇÃO IMPL.
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite a Situação Impl."
                id="situacaoimplantacao"
                name="situacaoimplantacao"
                value={formValues.situacaoimplantacao || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.situacaodaintegracao && (
            <FormGroup>
              <Label for="situacaodaintegracao" className="fw-bold">
                SITUAÇÃO INT.
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite a Situação Int."
                id="situacaodaintegracao"
                name="situacaodaintegracao"
                value={formValues.situacaodaintegracao || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datadacriacaodademandadia && (
            <FormGroup>
              <Label for="datadacriacaodademandadia" className="fw-bold">
                DATA CRIAÇÃO DEMANDA
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datadacriacaodademandadia"
                name="datadacriacaodademandadia"
                value={formValues.datadacriacaodademandadia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {/* Campos de data */}
          {fieldVisibility.datalimiteaceitedia && (
            <FormGroup>
              <Label for="datalimiteaceitedia" className="fw-bold">
                DATA LIMITE ACEITE
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datalimiteaceitedia"
                name="datalimiteaceitedia"
                value={formValues.datalimiteaceitedia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.dataaceitedemandadia && (
            <FormGroup>
              <Label for="dataaceitedemandadia" className="fw-bold">
                DATA ACEITE DEMANDA
              </Label>
              <Input
                type="date"
                className="form-control"
                id="dataaceitedemandadia"
                name="dataaceitedemandadia"
                value={formValues.dataaceitedemandadia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datainicioprevistasolicitantebaselinemosdia && (
            <FormGroup>
              <Label for="datainicioprevistasolicitantebaselinemosdia" className="fw-bold">
                INÍCIO PREV. SOLICITANTE
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datainicioprevistasolicitantebaselinemosdia"
                name="datainicioprevistasolicitantebaselinemosdia"
                value={formValues.datainicioprevistasolicitantebaselinemosdia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datainicioentregamosplanejadodia && (
            <FormGroup>
              <Label for="datainicioentregamosplanejadodia" className="fw-bold">
                INÍCIO ENTREGA PLANEJADA
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datainicioentregamosplanejadodia"
                name="datainicioentregamosplanejadodia"
                value={formValues.datainicioentregamosplanejadodia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datarecebimentodositemosreportadodia && (
            <FormGroup>
              <Label for="datarecebimentodositemosreportadodia" className="fw-bold">
                RECEBIMENTO REPORTADO
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datarecebimentodositemosreportadodia"
                name="datarecebimentodositemosreportadodia"
                value={formValues.datarecebimentodositemosreportadodia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datafimprevistabaselinefiminstalacaodia && (
            <FormGroup>
              <Label for="datafimprevistabaselinefiminstalacaodia" className="fw-bold">
                FIM PREV. BASELINE INST.
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datafimprevistabaselinefiminstalacaodia"
                name="datafimprevistabaselinefiminstalacaodia"
                value={formValues.datafimprevistabaselinefiminstalacaodia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datafiminstalacaoplanejadodia && (
            <FormGroup>
              <Label for="datafiminstalacaoplanejadodia" className="fw-bold">
                FIM INST. PLANEJADA
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datafiminstalacaoplanejadodia"
                name="datafiminstalacaoplanejadodia"
                value={formValues.datafiminstalacaoplanejadodia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.dataconclusaoreportadodia && (
            <FormGroup>
              <Label for="dataconclusaoreportadodia" className="fw-bold">
                CONCLUSÃO REPORTADA
              </Label>
              <Input
                type="date"
                className="form-control"
                id="dataconclusaoreportadodia"
                name="dataconclusaoreportadodia"
                value={formValues.dataconclusaoreportadodia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datavalidacaoinstalacaodia && (
            <FormGroup>
              <Label for="datavalidacaoinstalacaodia" className="fw-bold">
                VALIDAÇÃO INSTALAÇÃO
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datavalidacaoinstalacaodia"
                name="datavalidacaoinstalacaodia"
                value={formValues.datavalidacaoinstalacaodia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.dataintegracaobaselinedia && (
            <FormGroup>
              <Label for="dataintegracaobaselinedia" className="fw-bold">
                INTEGRAÇÃO BASELINE
              </Label>
              <Input
                type="date"
                className="form-control"
                id="dataintegracaobaselinedia"
                name="dataintegracaobaselinedia"
                value={formValues.dataintegracaobaselinedia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.dataintegracaoplanejadodia && (
            <FormGroup>
              <Label for="dataintegracaoplanejadodia" className="fw-bold">
                INTEGRAÇÃO PLANEJADA
              </Label>
              <Input
                type="date"
                className="form-control"
                id="dataintegracaoplanejadodia"
                name="dataintegracaoplanejadodia"
                value={formValues.dataintegracaoplanejadodia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datavalidacaoeriboxedia && (
            <FormGroup>
              <Label for="datavalidacaoeriboxedia" className="fw-bold">
                VALIDAÇÃO ERIBOXE
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datavalidacaoeriboxedia"
                name="datavalidacaoeriboxedia"
                value={formValues.datavalidacaoeriboxedia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.datadefimdaaceitacaosydledia && (
            <FormGroup>
              <Label for="datadefimdaaceitacaosydledia" className="fw-bold">
                FIM ACEITE SYDLE
              </Label>
              <Input
                type="date"
                className="form-control"
                id="datadefimdaaceitacaosydledia"
                name="datadefimdaaceitacaosydledia"
                value={formValues.datadefimdaaceitacaosydledia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.rsavalidacaorsanrotrackerdatafimdia && (
            <FormGroup>
              <Label for="rsavalidacaorsanrotrackerdatafimdia" className="fw-bold">
                FIM VALIDAÇÃO RSA TRACKER
              </Label>
              <Input
                type="date"
                className="form-control"
                id="rsavalidacaorsanrotrackerdatafimdia"
                name="rsavalidacaorsanrotrackerdatafimdia"
                value={formValues.rsavalidacaorsanrotrackerdatafimdia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.fimdeobraplandia && (
            <FormGroup>
              <Label for="fimdeobraplandia" className="fw-bold">
                FIM OBRA PLAN.
              </Label>
              <Input
                type="date"
                className="form-control"
                id="fimdeobraplandia"
                name="fimdeobraplandia"
                value={formValues.fimdeobraplandia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.fimdeobrarealdia && (
            <FormGroup>
              <Label for="fimdeobrarealdia" className="fw-bold">
                FIM OBRA REAL
              </Label>
              <Input
                type="date"
                className="form-control"
                id="fimdeobrarealdia"
                name="fimdeobrarealdia"
                value={formValues.fimdeobrarealdia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {/* Campos de texto */}
          {fieldVisibility.listadepos && (
            <FormGroup>
              <Label for="listadepos" className="fw-bold">
                LISTA DE POS
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Lista de POS"
                id="listadepos"
                name="listadepos"
                value={formValues.listadepos || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.gestordeimplantacaonome && (
            <FormGroup>
              <Label for="gestordeimplantacaonome" className="fw-bold">
                GESTOR IMPL.
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Gestor Impl."
                id="gestordeimplantacaonome"
                name="gestordeimplantacaonome"
                value={formValues.gestordeimplantacaonome || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.statusrsa && (
            <FormGroup>
              <Label for="statusrsa" className="fw-bold">
                STATUS RSA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Status RSA"
                id="statusrsa"
                name="statusrsa"
                value={formValues.statusrsa || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.rsarsa && (
            <FormGroup>
              <Label for="rsarsa" className="fw-bold">
                RSA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite RSA"
                id="rsarsa"
                name="rsarsa"
                value={formValues.rsarsa || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.arqsvalidadapelocliente && (
            <FormGroup>
              <Label for="arqsvalidadapelocliente" className="fw-bold">
                DOCS VALIDADOS
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Docs Validados"
                id="arqsvalidadapelocliente"
                name="arqsvalidadapelocliente"
                value={formValues.arqsvalidadapelocliente || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.statusaceitacao && (
            <FormGroup>
              <Label for="statusaceitacao" className="fw-bold">
                STATUS ACEITE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Status Aceite"
                id="statusaceitacao"
                name="statusaceitacao"
                value={formValues.statusaceitacao || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.ordemdevenda && (
            <FormGroup>
              <Label for="ordemdevenda" className="fw-bold">
                ORDEM DE VENDA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Ordem de Venda"
                id="ordemdevenda"
                name="ordemdevenda"
                value={formValues.ordemdevenda || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.coordenadoaspnome && (
            <FormGroup>
              <Label for="coordenadoaspnome" className="fw-bold">
                COORDENADOR ASP
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Coordenador ASP"
                id="coordenadoaspnome"
                name="coordenadoaspnome"
                value={formValues.coordenadoaspnome || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.tipoatualizacaofam && (
            <FormGroup>
              <Label for="tipoatualizacaofam" className="fw-bold">
                TIPO ATUALIZAÇÃO FAM
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Tipo Atualização FAM"
                id="tipoatualizacaofam"
                name="tipoatualizacaofam"
                value={formValues.tipoatualizacaofam || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.sinergia && (
            <FormGroup>
              <Label for="sinergia" className="fw-bold">
                SINERGIA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Sinergia"
                id="sinergia"
                name="sinergia"
                value={formValues.sinergia || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.sinergia5g && (
            <FormGroup>
              <Label for="sinergia5g" className="fw-bold">
                SINERGIA 5G
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Sinergia 5G"
                id="sinergia5g"
                name="sinergia5g"
                value={formValues.sinergia5g || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.escoponome && (
            <FormGroup>
              <Label for="escoponome" className="fw-bold">
                ESCOPO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Escopo"
                id="escoponome"
                name="escoponome"
                value={formValues.escoponome || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.slapadraoescopodias && (
            <FormGroup>
              <Label for="slapadraoescopodias" className="fw-bold">
                SLA PADRÃO (DIAS)
              </Label>
              <Input
                type="number"
                className="form-control"
                placeholder="Digite SLA Padrão"
                id="slapadraoescopodias"
                name="slapadraoescopodias"
                value={formValues.slapadraoescopodias || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.tempoparalisacaoinstalacaodias && (
            <FormGroup>
              <Label for="tempoparalisacaoinstalacaodias" className="fw-bold">
                TEMPO PARALISAÇÃO (DIAS)
              </Label>
              <Input
                type="number"
                className="form-control"
                placeholder="Digite Tempo Paralisação"
                id="tempoparalisacaoinstalacaodias"
                name="tempoparalisacaoinstalacaodias"
                value={formValues.tempoparalisacaoinstalacaodias || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.localizacaositeendereco && (
            <FormGroup>
              <Label for="localizacaositeendereco" className="fw-bold">
                ENDEREÇO SITE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Endereço Site"
                id="localizacaositeendereco"
                name="localizacaositeendereco"
                value={formValues.localizacaositeendereco || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.localizacaositecidade && (
            <FormGroup>
              <Label for="localizacaositecidade" className="fw-bold">
                CIDADE SITE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Cidade Site"
                id="localizacaositecidade"
                name="localizacaositecidade"
                value={formValues.localizacaositecidade || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.documentacaosituacao && (
            <FormGroup>
              <Label for="documentacaosituacao" className="fw-bold">
                SITUAÇÃO DOC.
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Situação Doc."
                id="documentacaosituacao"
                name="documentacaosituacao"
                value={formValues.documentacaosituacao || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.statusdoc && (
            <FormGroup>
              <Label for="statusdoc" className="fw-bold">
                STATUS DOC
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Status Doc"
                id="statusdoc"
                name="statusdoc"
                value={formValues.statusdoc || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.aprovacaotodosdocs && (
            <FormGroup>
              <Label for="aprovacaotodosdocs" className="fw-bold">
                APROVAÇÃO TODOS DOCS
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Aprovação Todos Docs"
                id="aprovacaotodosdocs"
                name="aprovacaotodosdocs"
                value={formValues.aprovacaotodosdocs || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}

          {fieldVisibility.sitepossuirisco && (
            <FormGroup>
              <Label for="sitepossuirisco" className="fw-bold">
                SITE POSSUI RISCO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite Site Possui Risco"
                id="sitepossuirisco"
                name="sitepossuirisco"
                value={formValues.sitepossuirisco || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
        </div>
      </ModalBody>
      <ModalFooter className="d-flex justify-content-between">
        <Button
          color="none"
          className="d-flex align-items-center"
          onClick={toggleConfigModal}
          size="sm"
        >
          <SettingsIcon fontSize="small" className="me-1" /> Configurar Filtro
        </Button>
        <div className="d-flex justify-content-between gap-2">
          <Button color="primary" onClick={aplicarFiltro}>
            <FilterAltIcon fontSize="small" className="me-1" /> Aplicar Filtro
          </Button>{' '}
          <Button color="warning" onClick={limparFiltro}>
            <ClearIcon fontSize="small" className="me-1" /> Limpar Filtro
          </Button>{' '}
          <Button color="secondary" onClick={toggle1}>
            Cancelar
          </Button>
        </div>
      </ModalFooter>
    </Modal>
  );
};

FiltroRolloutEricsson.propTypes = {
  show1: PropTypes.bool.isRequired,
  toggle1: PropTypes.func.isRequired,
  toggleConfigModal: PropTypes.func.isRequired,
  fieldVisibility: PropTypes.object.isRequired,
  formValues: PropTypes.object.isRequired,
  setFormValues: PropTypes.func.isRequired,
  limparFiltro: PropTypes.func.isRequired,
  aplicarFiltro: PropTypes.func.isRequired,
};
export default FiltroRolloutEricsson;
