import {
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Form,
  FormGroup,
  Label,
  Input,
} from 'reactstrap';
import PropTypes from 'prop-types';
import { useEffect, useState } from 'react';
import SettingsIcon from '@mui/icons-material/Settings';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import ConfiguracaoCamposVisiveis from './ConfiguracaoCamposVisiveis';

const FiltroRolloutTelefonica = ({ toggle, atualiza, filter, setFilter }) => {
  const [configModalOpen, setConfigModalOpen] = useState(false);
  const [formValues, setFormValues] = useState({});
  const [save, setSave] = useState(false);

  useEffect(() => {
    setFormValues(filter);
  }, [filter]);

  // Estado para controlar a visibilidade de cada campo
  const [fieldVisibility, setFieldVisibility] = useState({
    pmoRef: true,
    pmoCategoria: true,
    uidIdpmts: true,
    ufSigla: true,
    pmoSigla: true,
    pmoUf: true,
    pmoRegional: true,
    statusObra: true,
    documentacao: true,
    initialTunningReal: true,
    dtReal: true,
    fimInstalacaoPlan: true,
    integracaoPlan: true,
    initialTunningStatus: true,
    dtPlan: true,
    rollout: true,
    acionamento: true,
    nomeSite: true,
    endereco: true,
    rsoRsaDetentora: true,
    rsoRsaIdDetentora: true,
    resumoFase: true,
    infraVivo: true,
    equipe: true,
    docaPlan: true,
    deliveryPlan: true,
    ov: true,
    acesso: true,
    t2Instalacao: true,
    numeroReqInst: true,
    numeroT2Inst: true,
    pedidoInst: true,
    t2Vistoria: true,
    numeroReqVist: true,
    numeroT2Vist: true,
    pedidoVist: true,
  });

  // Toggle para abrir/fechar o modal de configuração
  const toggleConfigModal = () => {
    setConfigModalOpen(!configModalOpen);
  };

  const applyFilter = () => {
    setFilter(formValues);
    setSave(true);
  };

  useEffect(() => {
    if (save) {
      atualiza(formValues); // Pass the filtered values if needed
      toggle();
    }
  }, [save]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormValues({
      ...formValues,
      [name]: value,
    });
  };

  return (
    <Modal
      isOpen
      toggle={toggle}
      className="modal-dialog modal-lg modal-dialog-scrollable"
      backdrop="static"
      keyboard={false}
      size="lg"
    >
      <ModalHeader toggle={toggle} className=" border-bottom">
        <span className="fw-bold">Filtro de Pesquisa</span>
      </ModalHeader>
      <ModalBody className="px-4 py-3">
        <Form>
          {fieldVisibility.pmoRef && (
            <FormGroup>
              <Label for="pmoRef" className="fw-bold">
                PMO - REF
              </Label>
              <Input
                type="select"
                id="pmoRef"
                name="pmoRef"
                className="form-select"
                aria-label="Filtro PMO - REF"
                value={formValues.pmoRef || ''}
                onChange={handleInputChange}
              >
                <option value="" disabled>
                  SELECIONE PMO-REF
                </option>
                <option value="Rollout_2025">Rollout_2025</option>
                <option value="Rollout_2026">Rollout_2026</option>
              </Input>
            </FormGroup>
          )}

          {fieldVisibility.pmoCategoria && (
            <FormGroup>
              <Label for="pmoCategoria" className="fw-bold">
                PMO - CATEGORIA
              </Label>
              <Input
                type="select"
                id="pmoCategoria"
                name="pmoCategoria"
                className="form-select"
                aria-label="Filtro PMO - CATEGORIA"
                value={formValues.pmoCategoria || ''}
                onChange={handleInputChange}
              >
                <option value="" disabled>
                  SELECIONE CATEGORIA
                </option>
                <option value="Existente">Existente</option>
                <option value="Novo">Novo</option>
              </Input>
            </FormGroup>
          )}

          {fieldVisibility.uidIdpmts && (
            <FormGroup>
              <Label for="uidIdpmts" className="fw-bold">
                UID - IDPMTS
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o UID - IDPMTS"
                id="uidIdpmts"
                name="uidIdpmts"
                value={formValues.uidIdpmts || ''}
                onChange={handleInputChange}
                aria-label="Filtro UID - IDPMTS"
              />
            </FormGroup>
          )}

          {fieldVisibility.ufSigla && (
            <FormGroup>
              <Label for="ufSigla" className="fw-bold">
                UF/SIGLA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite a UF/SIGLA"
                id="ufSigla"
                name="ufSigla"
                value={formValues.ufSigla || ''}
                onChange={handleInputChange}
                aria-label="Filtro UF/SIGLA"
              />
            </FormGroup>
          )}

          {fieldVisibility.pmoSigla && (
            <FormGroup>
              <Label for="pmoSigla" className="fw-bold">
                PMO - SIGLA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o PMO - SIGLA"
                id="pmoSigla"
                name="pmoSigla"
                value={formValues.pmoSigla || ''}
                onChange={handleInputChange}
                aria-label="Filtro PMO - SIGLA"
              />
            </FormGroup>
          )}

          {fieldVisibility.pmoUf && (
            <FormGroup>
              <Label for="pmoUf" className="fw-bold">
                PMO - UF
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o PMO - UF"
                id="pmoUf"
                name="pmoUf"
                value={formValues.pmoUf || ''}
                onChange={handleInputChange}
                aria-label="Filtro PMO - UF"
              />
            </FormGroup>
          )}

          {fieldVisibility.pmoRegional && (
            <FormGroup>
              <Label for="pmoRegional" className="fw-bold">
                PMO - REGIONAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite o PMO - REGIONAL"
                id="pmoRegional"
                name="pmoRegional"
                value={formValues.pmoRegional || ''}
                onChange={handleInputChange}
                aria-label="Filtro PMO - REGIONAL"
              />
            </FormGroup>
          )}

          {fieldVisibility.cidade && (
            <FormGroup>
              <Label for="cidade" className="fw-bold">
                CIDADE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite a CIDADE"
                id="cidade"
                name="cidade"
                value={formValues.cidade || ''}
                onChange={handleInputChange}
                aria-label="Filtro CIDADE"
              />
            </FormGroup>
          )}

          {fieldVisibility.eapAutomatica && (
            <FormGroup>
              <Label for="eapAutomatica" className="fw-bold">
                EAP - AUTOMATICA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite EAP - AUTOMATICA"
                id="eapAutomatica"
                name="eapAutomatica"
                value={formValues.eapAutomatica || ''}
                onChange={handleInputChange}
                aria-label="Filtro EAP - AUTOMATICA"
              />
            </FormGroup>
          )}

          {fieldVisibility.regionalEapInfra && (
            <FormGroup>
              <Label for="regionalEapInfra" className="fw-bold">
                REGIONAL - EAP - INFRA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL - EAP - INFRA"
                id="regionalEapInfra"
                name="regionalEapInfra"
                value={formValues.regionalEapInfra || ''}
                onChange={handleInputChange}
                aria-label="Filtro REGIONAL - EAP - INFRA"
              />
            </FormGroup>
          )}

          {fieldVisibility.statusMensalTx && (
            <FormGroup>
              <Label for="statusMensalTx" className="fw-bold">
                STATUS-MENSAL-TX
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite STATUS-MENSAL-TX"
                id="statusMensalTx"
                name="statusMensalTx"
                value={formValues.statusMensalTx || ''}
                onChange={handleInputChange}
                aria-label="Filtro STATUS-MENSAL-TX"
              />
            </FormGroup>
          )}

          {fieldVisibility.masterObrStatusRollout && (
            <FormGroup>
              <Label for="masterObrStatusRollout" className="fw-bold">
                MASTEROBR-STATUS-ROLLOUT
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite MASTEROBR-STATUS-ROLLOUT"
                id="masterObrStatusRollout"
                name="masterObrStatusRollout"
                value={formValues.masterObrStatusRollout || ''}
                onChange={handleInputChange}
                aria-label="Filtro MASTEROBR-STATUS-ROLLOUT"
              />
            </FormGroup>
          )}

          {fieldVisibility.regionalLibSiteP && (
            <FormGroup>
              <Label for="regionalLibSiteP" className="fw-bold">
                REGIONAL-LIB-SITE-P
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL-LIB-SITE-P"
                id="regionalLibSiteP"
                name="regionalLibSiteP"
                value={formValues.regionalLibSiteP || ''}
                onChange={handleInputChange}
                aria-label="Filtro REGIONAL-LIB-SITE-P"
              />
            </FormGroup>
          )}

          {fieldVisibility.equipamentoEntregaP && (
            <FormGroup>
              <Label for="equipamentoEntregaP" className="fw-bold">
                EQUIPAMENTO-ENTREGA-P
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite EQUIPAMENTO-ENTREGA-P"
                id="equipamentoEntregaP"
                name="equipamentoEntregaP"
                value={formValues.equipamentoEntregaP || ''}
                onChange={handleInputChange}
                aria-label="Filtro EQUIPAMENTO-ENTREGA-P"
              />
            </FormGroup>
          )}

          {fieldVisibility.regionalCarimbo && (
            <FormGroup>
              <Label for="regionalCarimbo" className="fw-bold">
                REGIONAL-CARIMBO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL-CARIMBO"
                id="regionalCarimbo"
                name="regionalCarimbo"
                value={formValues.regionalCarimbo || ''}
                onChange={handleInputChange}
                aria-label="Filtro REGIONAL-CARIMBO"
              />
            </FormGroup>
          )}

          {fieldVisibility.rsoRsaSci && (
            <FormGroup>
              <Label for="rsoRsaSci" className="fw-bold">
                RSO-RSA-SCI
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-SCI"
                id="rsoRsaSci"
                name="rsoRsaSci"
                value={formValues.rsoRsaSci || ''}
                onChange={handleInputChange}
                aria-label="Filtro RSO-RSA-SCI"
              />
            </FormGroup>
          )}

          {fieldVisibility.rsoRsaSciStatus && (
            <FormGroup>
              <Label for="rsoRsaSciStatus" className="fw-bold">
                RSO-RSA-SCI-STATUS
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-SCI-STATUS"
                id="rsoRsaSciStatus"
                name="rsoRsaSciStatus"
                value={formValues.rsoRsaSciStatus || ''}
                onChange={handleInputChange}
                aria-label="Filtro RSO-RSA-SCI-STATUS"
              />
            </FormGroup>
          )}

          {fieldVisibility.regionalOfensorDetalhe && (
            <FormGroup>
              <Label for="regionalOfensorDetalhe" className="fw-bold">
                REGIONAL-OFENSOR-DETALHE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL-OFENSOR-DETALHE"
                id="regionalOfensorDetalhe"
                name="regionalOfensorDetalhe"
                value={formValues.regionalOfensorDetalhe || ''}
                onChange={handleInputChange}
                aria-label="Filtro REGIONAL-OFENSOR-DETALHE"
              />
            </FormGroup>
          )}

          {fieldVisibility.vendorVistoria && (
            <FormGroup>
              <Label for="vendorVistoria" className="fw-bold">
                VENDOR-VISTORIA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-VISTORIA"
                id="vendorVistoria"
                name="vendorVistoria"
                value={formValues.vendorVistoria || ''}
                onChange={handleInputChange}
                aria-label="Filtro VENDOR-VISTORIA"
              />
            </FormGroup>
          )}

          {fieldVisibility.vendorProjeto && (
            <FormGroup>
              <Label for="vendorProjeto" className="fw-bold">
                VENDOR-PROJETO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-PROJETO"
                id="vendorProjeto"
                name="vendorProjeto"
                value={formValues.vendorProjeto || ''}
                onChange={handleInputChange}
                aria-label="Filtro VENDOR-PROJETO"
              />
            </FormGroup>
          )}

          {fieldVisibility.vendorInstalador && (
            <FormGroup>
              <Label for="vendorInstalador" className="fw-bold">
                VENDOR-INSTALADOR
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-INSTALADOR"
                id="vendorInstalador"
                name="vendorInstalador"
                value={formValues.vendorInstalador || ''}
                onChange={handleInputChange}
                aria-label="Filtro VENDOR-INSTALADOR"
              />
            </FormGroup>
          )}

          {fieldVisibility.vendorIntegrador && (
            <FormGroup>
              <Label for="vendorIntegrador" className="fw-bold">
                VENDOR-INTEGRADOR
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-INTEGRADOR"
                id="vendorIntegrador"
                name="vendorIntegrador"
                value={formValues.vendorIntegrador || ''}
                onChange={handleInputChange}
                aria-label="Filtro VENDOR-INTEGRADOR"
              />
            </FormGroup>
          )}

          {fieldVisibility.pmoTecnEquip && (
            <FormGroup>
              <Label for="pmoTecnEquip" className="fw-bold">
                PMO-TECN-EQUIP
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite PMO-TECN-EQUIP"
                id="pmoTecnEquip"
                name="pmoTecnEquip"
                value={formValues.pmoTecnEquip || ''}
                onChange={handleInputChange}
                aria-label="Filtro PMO-TECN-EQUIP"
              />
            </FormGroup>
          )}

          {fieldVisibility.pmoFreqEquip && (
            <FormGroup>
              <Label for="pmoFreqEquip" className="fw-bold">
                PMO-FREQ-EQUIP
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite PMO-FREQ-EQUIP"
                id="pmoFreqEquip"
                name="pmoFreqEquip"
                value={formValues.pmoFreqEquip || ''}
                onChange={handleInputChange}
                aria-label="Filtro PMO-FREQ-EQUIP"
              />
            </FormGroup>
          )}

          {fieldVisibility.uidIdcpomrf && (
            <FormGroup>
              <Label for="uidIdcpomrf" className="fw-bold">
                UID-IDCPOMRF
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite UID-IDCPOMRF"
                id="uidIdcpomrf"
                name="uidIdcpomrf"
                value={formValues.uidIdcpomrf || ''}
                onChange={handleInputChange}
                aria-label="Filtro UID-IDCPOMRF"
              />
            </FormGroup>
          )}

          {fieldVisibility.statusObra && (
            <FormGroup>
              <Label for="statusObra" className="fw-bold">
                STATUS OBRA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite STATUS OBRA"
                id="statusObra"
                name="statusObra"
                value={formValues.statusObra || ''}
                onChange={handleInputChange}
                aria-label="Filtro STATUS OBRA"
              />
            </FormGroup>
          )}

          {fieldVisibility.docPlan && (
            <FormGroup>
              <Label for="docPlan" className="fw-bold">
                DOC PLAN
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite DOC PLAN"
                id="docPlan"
                name="docPlan"
                value={formValues.docPlan || ''}
                onChange={handleInputChange}
                aria-label="Filtro DOC PLAN"
              />
            </FormGroup>
          )}

          {fieldVisibility.entregaRequest && (
            <FormGroup>
              <Label for="entregaRequest" className="fw-bold">
                ENTREGA-REQUEST
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ENTREGA-REQUEST"
                id="entregaRequest"
                name="entregaRequest"
                value={formValues.entregaRequest || ''}
                onChange={handleInputChange}
                aria-label="Filtro ENTREGA-REQUEST"
              />
            </FormGroup>
          )}

          {fieldVisibility.entregaPlan && (
            <FormGroup>
              <Label for="entregaPlan" className="fw-bold">
                ENTREGA-PLAN
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ENTREGA-PLAN"
                id="entregaPlan"
                name="entregaPlan"
                value={formValues.entregaPlan || ''}
                onChange={handleInputChange}
                aria-label="Filtro ENTREGA-PLAN"
              />
            </FormGroup>
          )}

          {fieldVisibility.vistoriaReal && (
            <FormGroup>
              <Label for="vistoriaReal" className="fw-bold">
                VISTORIA-REAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite VISTORIA-REAL"
                id="vistoriaReal"
                name="vistoriaReal"
                value={formValues.vistoriaReal || ''}
                onChange={handleInputChange}
                aria-label="Filtro VISTORIA-REAL"
              />
            </FormGroup>
          )}

          {fieldVisibility.entregaReal && (
            <FormGroup>
              <Label for="entregaReal" className="fw-bold">
                ENTREGA-REAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ENTREGA-REAL"
                id="entregaReal"
                name="entregaReal"
                value={formValues.entregaReal || ''}
                onChange={handleInputChange}
                aria-label="Filtro ENTREGA-REAL"
              />
            </FormGroup>
          )}

          {fieldVisibility.fimInstalacaoReal && (
            <FormGroup>
              <Label for="fimInstalacaoReal" className="fw-bold">
                FIM INSTALAÇÃO REAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite FIM INSTALAÇÃO REAL"
                id="fimInstalacaoReal"
                name="fimInstalacaoReal"
                value={formValues.fimInstalacaoReal || ''}
                onChange={handleInputChange}
                aria-label="Filtro FIM INSTALAÇÃO REAL"
              />
            </FormGroup>
          )}

          {fieldVisibility.integracaoReal && (
            <FormGroup>
              <Label for="integracaoReal" className="fw-bold">
                INTEGRAÇÃO REAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite INTEGRAÇÃO REAL"
                id="integracaoReal"
                name="integracaoReal"
                value={formValues.integracaoReal || ''}
                onChange={handleInputChange}
                aria-label="Filtro INTEGRAÇÃO REAL"
              />
            </FormGroup>
          )}

          {fieldVisibility.ativacao && (
            <FormGroup>
              <Label for="ativacao" className="fw-bold">
                ATIVAÇÃO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ATIVAÇÃO"
                id="ativacao"
                name="ativacao"
                value={formValues.ativacao || ''}
                onChange={handleInputChange}
                aria-label="Filtro ATIVAÇÃO"
              />
            </FormGroup>
          )}

          {fieldVisibility.documentacao && (
            <FormGroup>
              <Label for="documentacao" className="fw-bold">
                DOCUMENTAÇÃO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite DOCUMENTAÇÃO"
                id="documentacao"
                name="documentacao"
                value={formValues.documentacao || ''}
                onChange={handleInputChange}
                aria-label="Filtro DOCUMENTAÇÃO"
              />
            </FormGroup>
          )}

          {fieldVisibility.initialTunningReal && (
            <FormGroup>
              <Label for="initialTunningReal" className="fw-bold">
                INITIAL TUNNING REAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite INITIAL TUNNING REAL"
                id="initialTunningReal"
                name="initialTunningReal"
                value={formValues.initialTunningReal || ''}
                onChange={handleInputChange}
                aria-label="Filtro INITIAL TUNNING REAL"
              />
            </FormGroup>
          )}

          {fieldVisibility.dtReal && (
            <FormGroup>
              <Label for="dtReal" className="fw-bold">
                DT REAL
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite DT REAL"
                id="dtReal"
                name="dtReal"
                value={formValues.dtReal || ''}
                onChange={handleInputChange}
                aria-label="Filtro DT REAL"
              />
            </FormGroup>
          )}

          {fieldVisibility.fimInstalacaoPlan && (
            <FormGroup>
              <Label for="fimInstalacaoPlan" className="fw-bold">
                FIM INSTALAÇÃO PLAN
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite FIM INSTALAÇÃO PLAN"
                id="fimInstalacaoPlan"
                name="fimInstalacaoPlan"
                value={formValues.fimInstalacaoPlan || ''}
                onChange={handleInputChange}
                aria-label="Filtro FIM INSTALAÇÃO PLAN"
              />
            </FormGroup>
          )}

          {fieldVisibility.integracaoPlan && (
            <FormGroup>
              <Label for="integracaoPlan" className="fw-bold">
                INTEGRAÇÃO PLAN
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite INTEGRAÇÃO PLAN"
                id="integracaoPlan"
                name="integracaoPlan"
                value={formValues.integracaoPlan || ''}
                onChange={handleInputChange}
                aria-label="Filtro INTEGRAÇÃO PLAN"
              />
            </FormGroup>
          )}

          {fieldVisibility.initialTunningStatus && (
            <FormGroup>
              <Label for="initialTunningStatus" className="fw-bold">
                INITIAL TUNNING STATUS
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite INITIAL TUNNING STATUS"
                id="initialTunningStatus"
                name="initialTunningStatus"
                value={formValues.initialTunningStatus || ''}
                onChange={handleInputChange}
                aria-label="Filtro INITIAL TUNNING STATUS"
              />
            </FormGroup>
          )}

          {fieldVisibility.dtPlan && (
            <FormGroup>
              <Label for="dtPlan" className="fw-bold">
                DT PLAN
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite DT PLAN"
                id="dtPlan"
                name="dtPlan"
                value={formValues.dtPlan || ''}
                onChange={handleInputChange}
                aria-label="Filtro DT PLAN"
              />
            </FormGroup>
          )}

          {fieldVisibility.rollout && (
            <FormGroup>
              <Label for="rollout" className="fw-bold">
                ROLLOUT
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ROLLOUT"
                id="rollout"
                name="rollout"
                value={formValues.rollout || ''}
                onChange={handleInputChange}
                aria-label="Filtro ROLLOUT"
              />
            </FormGroup>
          )}

          {fieldVisibility.acionamento && (
            <FormGroup>
              <Label for="acionamento" className="fw-bold">
                ACIONAMENTO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ACIONAMENTO"
                id="acionamento"
                name="acionamento"
                value={formValues.acionamento || ''}
                onChange={handleInputChange}
                aria-label="Filtro ACIONAMENTO"
              />
            </FormGroup>
          )}

          {fieldVisibility.nomeSite && (
            <FormGroup>
              <Label for="nomeSite" className="fw-bold">
                NOME DO SITE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite NOME DO SITE"
                id="nomeSite"
                name="nomeSite"
                value={formValues.nomeSite || ''}
                onChange={handleInputChange}
                aria-label="Filtro NOME DO SITE"
              />
            </FormGroup>
          )}

          {fieldVisibility.endereco && (
            <FormGroup>
              <Label for="endereco" className="fw-bold">
                ENDEREÇO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ENDEREÇO"
                id="endereco"
                name="endereco"
                value={formValues.endereco || ''}
                onChange={handleInputChange}
                aria-label="Filtro ENDEREÇO"
              />
            </FormGroup>
          )}

          {fieldVisibility.rsoRsaDetentora && (
            <FormGroup>
              <Label for="rsoRsaDetentora" className="fw-bold">
                RSO-RSA-DETENTORA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-DETENTORA"
                id="rsoRsaDetentora"
                name="rsoRsaDetentora"
                value={formValues.rsoRsaDetentora || ''}
                onChange={handleInputChange}
                aria-label="Filtro RSO-RSA-DETENTORA"
              />
            </FormGroup>
          )}

          {fieldVisibility.rsoRsaIdDetentora && (
            <FormGroup>
              <Label for="rsoRsaIdDetentora" className="fw-bold">
                RSO-RSA-ID-DENTETORA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-ID-DENTETORA"
                id="rsoRsaIdDetentora"
                name="rsoRsaIdDetentora"
                value={formValues.rsoRsaIdDetentora || ''}
                onChange={handleInputChange}
                aria-label="Filtro RSO-RSA-ID-DENTETORA"
              />
            </FormGroup>
          )}

          {fieldVisibility.resumoFase && (
            <FormGroup>
              <Label for="resumoFase" className="fw-bold">
                RESUMO DA FASE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite RESUMO DA FASE"
                id="resumoFase"
                name="resumoFase"
                value={formValues.resumoFase || ''}
                onChange={handleInputChange}
                aria-label="Filtro RESUMO DA FASE"
              />
            </FormGroup>
          )}

          {fieldVisibility.infraVivo && (
            <FormGroup>
              <Label for="infraVivo" className="fw-bold">
                INFRA VIVO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite INFRA VIVO"
                id="infraVivo"
                name="infraVivo"
                value={formValues.infraVivo || ''}
                onChange={handleInputChange}
                aria-label="Filtro INFRA VIVO"
              />
            </FormGroup>
          )}

          {fieldVisibility.equipe && (
            <FormGroup>
              <Label for="equipe" className="fw-bold">
                EQUIPE
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite EQUIPE"
                id="equipe"
                name="equipe"
                value={formValues.equipe || ''}
                onChange={handleInputChange}
                aria-label="Filtro EQUIPE"
              />
            </FormGroup>
          )}

          {fieldVisibility.docaPlan && (
            <FormGroup>
              <Label for="docaPlan" className="fw-bold">
                DOCA PLAN
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite DOCA PLAN"
                id="docaPlan"
                name="docaPlan"
                value={formValues.docaPlan || ''}
                onChange={handleInputChange}
                aria-label="Filtro DOCA PLAN"
              />
            </FormGroup>
          )}

          {fieldVisibility.deliveryPlan && (
            <FormGroup>
              <Label for="deliveryPlan" className="fw-bold">
                DELIVERY PLAN
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite DELIVERY PLAN"
                id="deliveryPlan"
                name="deliveryPlan"
                value={formValues.deliveryPlan || ''}
                onChange={handleInputChange}
                aria-label="Filtro DELIVERY PLAN"
              />
            </FormGroup>
          )}

          {fieldVisibility.ov && (
            <FormGroup>
              <Label for="ov" className="fw-bold">
                OV
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite OV"
                id="ov"
                name="ov"
                value={formValues.ov || ''}
                onChange={handleInputChange}
                aria-label="Filtro OV"
              />
            </FormGroup>
          )}

          {fieldVisibility.acesso && (
            <FormGroup>
              <Label for="acesso" className="fw-bold">
                ACESSO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite ACESSO"
                id="acesso"
                name="acesso"
                value={formValues.acesso || ''}
                onChange={handleInputChange}
                aria-label="Filtro ACESSO"
              />
            </FormGroup>
          )}

          {fieldVisibility.t2Instalacao && (
            <FormGroup>
              <Label for="t2Instalacao" className="fw-bold">
                T2 INSTALAÇÃO
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite T2 INSTALAÇÃO"
                id="t2Instalacao"
                name="t2Instalacao"
                value={formValues.t2Instalacao || ''}
                onChange={handleInputChange}
                aria-label="Filtro T2 INSTALAÇÃO"
              />
            </FormGroup>
          )}

          {fieldVisibility.numeroReqInst && (
            <FormGroup>
              <Label for="numeroReqInst" className="fw-bold">
                NÚMERO DA REQ - INST
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO DA REQ - INST"
                id="numeroReqInst"
                name="numeroReqInst"
                value={formValues.numeroReqInst || ''}
                onChange={handleInputChange}
                aria-label="Filtro NÚMERO DA REQ - INST"
              />
            </FormGroup>
          )}

          {fieldVisibility.numeroT2Inst && (
            <FormGroup>
              <Label for="numeroT2Inst" className="fw-bold">
                NÚMERO T2 - INST
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO T2 - INST"
                id="numeroT2Inst"
                name="numeroT2Inst"
                value={formValues.numeroT2Inst || ''}
                onChange={handleInputChange}
                aria-label="Filtro NÚMERO T2 - INST"
              />
            </FormGroup>
          )}

          {fieldVisibility.pedidoInst && (
            <FormGroup>
              <Label for="pedidoInst" className="fw-bold">
                PEDIDO - INST
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite PEDIDO - INST"
                id="pedidoInst"
                name="pedidoInst"
                value={formValues.pedidoInst || ''}
                onChange={handleInputChange}
                aria-label="Filtro PEDIDO - INST"
              />
            </FormGroup>
          )}

          {fieldVisibility.t2Vistoria && (
            <FormGroup>
              <Label for="t2Vistoria" className="fw-bold">
                T2 VISTORIA
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite T2 VISTORIA"
                id="t2Vistoria"
                name="t2Vistoria"
                value={formValues.t2Vistoria || ''}
                onChange={handleInputChange}
                aria-label="Filtro T2 VISTORIA"
              />
            </FormGroup>
          )}

          {fieldVisibility.numeroReqVist && (
            <FormGroup>
              <Label for="numeroReqVist" className="fw-bold">
                NÚMERO DA REQ - VIST
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO DA REQ - VIST"
                id="numeroReqVist"
                name="numeroReqVist"
                value={formValues.numeroReqVist || ''}
                onChange={handleInputChange}
                aria-label="Filtro NÚMERO DA REQ - VIST"
              />
            </FormGroup>
          )}

          {fieldVisibility.numeroT2Vist && (
            <FormGroup>
              <Label for="numeroT2Vist" className="fw-bold">
                NÚMERO T2 - VIST
              </Label>
              <Input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO T2 - VIST"
                id="numeroT2Vist"
                name="numeroT2Vist"
                value={formValues.numeroT2Vist || ''}
                onChange={handleInputChange}
                aria-label="Filtro NÚMERO T2 - VIST"
              />
            </FormGroup>
          )}

          {fieldVisibility.pedidoVist && (
            <FormGroup>
              <Label for="pedidoVist" className="fw-bold">
                PEDIDO - VIST
              </Label>
              <Input
                type="text"
                className="form-control"
                id="pedidoVist"
                name="pedidoVist"
                placeholder="Digite PEDIDO - VIST"
                value={formValues.pedidoVist || ''}
                onChange={handleInputChange}
                aria-label="Filtro PEDIDO - VIST"
              />
            </FormGroup>
          )}
        </Form>

        {/* Modal de configuração de campos visíveis */}
        <ConfiguracaoCamposVisiveis
          isOpen={configModalOpen}
          toggle={toggleConfigModal}
          fieldVisibility={fieldVisibility}
          setFieldVisibility={setFieldVisibility}
          LOCAL_STORAGE_KEY="rollouttelefonica"
        />
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
          <Button color="secondary" onClick={toggle} outline>
            Cancelar
          </Button>
          <Button color="primary" onClick={applyFilter}>
            <FilterAltIcon fontSize="small" className="me-1" /> Aplicar Filtro
          </Button>
        </div>
      </ModalFooter>
    </Modal>
  );
};

FiltroRolloutTelefonica.propTypes = {
  toggle: PropTypes.func.isRequired,
  filter: PropTypes.object.isRequired,
  setFilter: PropTypes.func.isRequired,
  atualiza: PropTypes.func.isRequired,
};

export default FiltroRolloutTelefonica;
