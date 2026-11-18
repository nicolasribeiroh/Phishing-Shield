package br.com.a3.phishingshield.repository;

import br.com.a3.phishingshield.model.PalavraChave;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PalavraChaveRepository extends JpaRepository<PalavraChave, Long> {

    /** Termos ativos de indicadores ativos, ja com o indicador carregado. */
    @Query("SELECT p FROM PalavraChave p JOIN FETCH p.indicador i "
            + "WHERE p.ativo = true AND i.ativo = true "
            + "ORDER BY i.ordem, i.id, p.id")
    List<PalavraChave> buscarTermosAtivos();
}
