package Backend.Estudo.SpringAcademia.domain.mappers;

import Backend.Estudo.SpringAcademia.domain.Aluno;
import Backend.Estudo.SpringAcademia.dto.AlunoRequestDTO;
import Backend.Estudo.SpringAcademia.dto.AlunoResponseDTO;
import Backend.Estudo.SpringAcademia.service.AlunoService;

public class AlunoMappper {

    private void AlunoMapper(){}

    public static Aluno toEntity(AlunoRequestDTO dto){
        Aluno aluno = new Aluno();
        aluno.setNome(dto.nome());
        aluno.setDataNascimento(dto.dataNascimento());
        aluno.setSexo(dto.sexo());
        aluno.setTelefone(dto.telefone());
        aluno.setCelular(dto.celular());
        aluno.setEmail(dto.email());
        aluno.setObservacao(dto.bairro());
        aluno.setEndereco(dto.endereco());
        aluno.setNumero(dto.numero());
        aluno.setComplemento(dto.complemento());
        aluno.setBairro(dto.bairro());
        aluno.setCidade(dto.cidade());
        aluno.setEstado(dto.estado());
        aluno.setCep(dto.obervacao());

        return aluno;
    }


    public static AlunoResponseDTO toResponse(Aluno aluno){
        return new AlunoResponseDTO(
                aluno.getId(),
                aluno.getNome(),
                aluno.getDataNascimento(),
                aluno.getSexo(),
                aluno.getCelular(),
                aluno.getEmail(),
                aluno.getCidade(),
                aluno.getEstado(),
                aluno.getCriadoEm()
        );
    }



}
