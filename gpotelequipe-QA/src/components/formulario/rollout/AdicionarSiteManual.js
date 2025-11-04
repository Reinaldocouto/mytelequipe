import { useState } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Button,
  Form,
  FormGroup,
  Label,
  Input,
  Row,
  Col,
  Alert,
} from 'reactstrap';
import Select from 'react-select';
import { toast } from 'react-toastify';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';

const infraOptions = [
  { value: 'CAMUFLADO', label: 'CAMUFLADO' },
  { value: 'GREENFIELD', label: 'GREENFIELD' },
  { value: 'INDOOR', label: 'INDOOR' },
  { value: 'MASTRO', label: 'MASTRO' },
  { value: 'POSTE METÁLICO', label: 'POSTE METÁLICO' },
  { value: 'ROOFTOP', label: 'ROOFTOP' },
  { value: 'TORRE METALICA', label: 'TORRE METALICA' },
  { value: 'SLS', label: 'SLS' },
];

const AdicionarSiteManual = ({ show, setShow, onSiteAdded }) => {
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    uididpmts: '',
    ufsigla: '',
    uididcpomrf: '',
    pmouf: '',
    pmoregional: '',
    idVivo: '',
    infra: '',
    detentora: '',
    idDetentora: '',
    fcu: '',
    rsoRsaSciStatus: '',
  });
  const [selectedInfra, setSelectedInfra] = useState(null);
  const [errors, setErrors] = useState({});
  const [duplicateCheck, setDuplicateCheck] = useState(null);

  const resetForm = () => {
    setFormData({
      uididpmts: '',
      ufsigla: '',
      uididcpomrf: '',
      pmouf: '',
      pmoregional: '',
      idVivo: '',
      infra: '',
      detentora: '',
      idDetentora: '',
      fcu: '',
      rsoRsaSciStatus: '',
    });
    setSelectedInfra(null);
    setErrors({});
    setDuplicateCheck(null);
  };

  const handleClose = () => {
    resetForm();
    setShow(false);
  };

  const handleInputChange = (field, value) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));

    // Limpar erro do campo quando o usuário começar a digitar
    if (errors[field]) {
      setErrors((prev) => ({
        ...prev,
        [field]: '',
      }));
    }
  };

  const handleInfraChange = (selectedOption) => {
    setSelectedInfra(selectedOption);
    handleInputChange('infra', selectedOption ? selectedOption.value : '');
  };

  const validateForm = () => {
    const newErrors = {};

    // Campos obrigatórios
    if (!formData.uididpmts.trim()) {
      newErrors.uididpmts = 'UID_IDPMTS é obrigatório';
    }
    if (!formData.ufsigla.trim()) {
      newErrors.ufsigla = 'UF/SIGLA é obrigatório';
    }
    if (!formData.uididcpomrf.trim()) {
      newErrors.uididcpomrf = 'UID_IDCPOMRF é obrigatório';
    }
    if (!formData.pmouf.trim()) {
      newErrors.pmouf = 'PMO_UF é obrigatório';
    }
    if (!formData.pmoregional.trim()) {
      newErrors.pmoregional = 'PMO_REGIONAL é obrigatório';
    }
    if (!formData.idVivo.trim()) {
      newErrors.idVivo = 'ID_VIVO é obrigatório';
    }
    if (!formData.infra.trim()) {
      newErrors.infra = 'INFRA é obrigatório';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const checkDuplicate = async () => {
    try {
      setLoading(true);
      const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        uididpmts: formData.uididpmts,
        uididcpomrf: formData.uididcpomrf,
      };

      const response = await api.get('v1/rollouttelefonica/verificarduplicidade', { params });

      if (response.data[0] > 0) {
        setDuplicateCheck({
          type: 'error',
          message: `Site já existe!`,
        });
        return false;
      }
      setDuplicateCheck({
        type: 'success',
        message: 'Site disponível para cadastro',
      });
      return true;
    } catch (error) {
      console.error('Erro ao verificar duplicidade:', error);
      toast.error('Erro ao verificar duplicidade do site');
      return false;
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!validateForm()) {
      toast.error('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    // Verificar duplicidade antes de salvar
    const isDuplicateValid = await checkDuplicate();
    if (!isDuplicateValid) {
      return;
    }

    try {
      setLoading(true);

      const payload = {
        ...formData,
        origem: 'Manual',
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        criadoPor: localStorage.getItem('sessionId'),
      };

      const response = await api.post('v1/rollouttelefonica/adicionarmanual', payload);

      if (response.status === 201) {
        toast.success('Site adicionado com sucesso!');
        handleClose();
        if (onSiteAdded) {
          onSiteAdded();
        }
      }
    } catch (error) {
      console.error('Erro ao adicionar site:', error);
      if (error.response?.data?.message) {
        toast.error(error.response.data.message);
      } else {
        toast.error('Erro ao adicionar site. Tente novamente.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      {loading && <Loader />}
      <Modal isOpen={show} toggle={handleClose} size="lg" backdrop="static">
        <ModalHeader toggle={handleClose}>Adicionar Site Manualmente</ModalHeader>
        <Form onSubmit={handleSubmit}>
          <ModalBody>
            {duplicateCheck && (
              <Alert color={duplicateCheck.type === 'error' ? 'danger' : 'success'}>
                {duplicateCheck.message}
              </Alert>
            )}

            <Row>
              <Col md={12}>
                <h6 className="mb-3 text-bold">Identificação</h6>
              </Col>
            </Row>

            <Row>
              <Col md={3}>
                <FormGroup>
                  <Label for="uididpmts">UID_IDPMTS *</Label>
                  <Input
                    type="text"
                    id="uididpmts"
                    value={formData.uididpmts}
                    onChange={(e) => handleInputChange('uididpmts', e.target.value)}
                    invalid={!!errors.uididpmts}
                    placeholder="Digite o UID_IDPMTS"
                  />
                  {errors.uididpmts && <div className="invalid-feedback">{errors.uididpmts}</div>}
                </FormGroup>
              </Col>
              <Col md={3}>
                <FormGroup>
                  <Label for="ufsigla">UF/SIGLA *</Label>
                  <Input
                    type="text"
                    id="ufsigla"
                    value={formData.ufsigla}
                    onChange={(e) => handleInputChange('ufsigla', e.target.value)}
                    invalid={!!errors.ufsigla}
                    placeholder="Digite a UF/SIGLA"
                  />
                  {errors.ufsigla && <div className="invalid-feedback">{errors.ufsigla}</div>}
                </FormGroup>
              </Col>
              <Col md={3}>
                <FormGroup>
                  <Label for="uididcpomrf">UID_IDCPOMRF *</Label>
                  <Input
                    type="text"
                    id="uididcpomrf"
                    value={formData.uididcpomrf}
                    onChange={(e) => handleInputChange('uididcpomrf', e.target.value)}
                    invalid={!!errors.uididcpomrf}
                    placeholder="Digite o UID_IDCPOMRF"
                  />
                  {errors.uididcpomrf && (
                    <div className="invalid-feedback">{errors.uididcpomrf}</div>
                  )}
                </FormGroup>
              </Col>
              <Col md={3}>
                <FormGroup>
                  <Label for="pmouf">PMO_UF *</Label>
                  <Input
                    type="text"
                    id="pmouf"
                    value={formData.pmouf}
                    onChange={(e) => handleInputChange('pmouf', e.target.value)}
                    invalid={!!errors.pmouf}
                    placeholder="Digite o PMO_UF"
                  />
                  {errors.pmouf && <div className="invalid-feedback">{errors.pmouf}</div>}
                </FormGroup>
              </Col>
            </Row>

            <Row>
              <Col md={3}>
                <FormGroup>
                  <Label for="pmoregional">PMO_REGIONAL *</Label>
                  <Input
                    type="text"
                    id="pmoregional"
                    value={formData.pmoregional}
                    onChange={(e) => handleInputChange('pmoregional', e.target.value)}
                    invalid={!!errors.pmoregional}
                    placeholder="Digite o PMO_REGIONAL"
                  />
                  {errors.pmoregional && (
                    <div className="invalid-feedback">{errors.pmoregional}</div>
                  )}
                </FormGroup>
              </Col>
            </Row>

            <Row>
              <Col md={12}>
                <h6 className="mb-3 text-bold">Acesso</h6>
              </Col>
            </Row>

            <Row>
              <Col md={3}>
                <FormGroup>
                  <Label for="idVivo">ID_VIVO *</Label>
                  <Input
                    type="text"
                    id="idVivo"
                    value={formData.idVivo}
                    onChange={(e) => handleInputChange('idVivo', e.target.value)}
                    invalid={!!errors.idVivo}
                    placeholder="Digite o ID_VIVO"
                  />
                  {errors.idVivo && <div className="invalid-feedback">{errors.idVivo}</div>}
                </FormGroup>
              </Col>
              <Col md={3}>
                <FormGroup>
                  <Label for="infra">INFRA *</Label>
                  <Select
                    id="infra"
                    value={selectedInfra}
                    onChange={handleInfraChange}
                    options={infraOptions}
                    placeholder="Selecione a INFRA"
                    isClearable
                    className={errors.infra ? 'is-invalid' : ''}
                  />
                  {errors.infra && <div className="invalid-feedback d-block">{errors.infra}</div>}
                </FormGroup>
              </Col>
              <Col md={3}>
                <FormGroup>
                  <Label for="detentora">DETENTORA</Label>
                  <Input
                    type="text"
                    id="detentora"
                    value={formData.detentora}
                    onChange={(e) => handleInputChange('detentora', e.target.value)}
                    placeholder="Digite a DETENTORA"
                  />
                </FormGroup>
              </Col>
              <Col md={3}>
                <FormGroup>
                  <Label for="idDetentora">ID DETENTORA</Label>
                  <Input
                    type="text"
                    id="idDetentora"
                    value={formData.idDetentora}
                    onChange={(e) => handleInputChange('idDetentora', e.target.value)}
                    placeholder="Digite o ID DETENTORA"
                  />
                </FormGroup>
              </Col>
            </Row>

            <Row>
              <Col md={3}>
                <FormGroup>
                  <Label for="fcu">FCU</Label>
                  <Input
                    type="text"
                    id="fcu"
                    value={formData.fcu}
                    onChange={(e) => handleInputChange('fcu', e.target.value)}
                    placeholder="Digite o FCU"
                  />
                </FormGroup>
              </Col>
              <Col md={3}>
                <FormGroup>
                  <Label for="rsoRsaSciStatus">RSO_RSA_SCI_STATUS</Label>
                  <Input
                    type="text"
                    id="rsoRsaSciStatus"
                    value={formData.rsoRsaSciStatus}
                    onChange={(e) => handleInputChange('rsoRsaSciStatus', e.target.value)}
                    placeholder="Digite o RSO_RSA_SCI_STATUS"
                  />
                </FormGroup>
              </Col>
            </Row>
          </ModalBody>
          <ModalFooter>
            <Button color="secondary" onClick={handleClose} disabled={loading}>
              Cancelar
            </Button>
            <Button color="primary" type="submit" disabled={loading}>
              {loading ? 'Salvando...' : 'Salvar Site'}
            </Button>
          </ModalFooter>
        </Form>
      </Modal>
    </>
  );
};

AdicionarSiteManual.propTypes = {
  show: PropTypes.bool.isRequired,
  setShow: PropTypes.func.isRequired,
  onSiteAdded: PropTypes.func,
};

export default AdicionarSiteManual;
