package br.com.a3.phishingshield.repository;

import br.com.a3.phishingshield.model.Indicador;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IndicadorRepository extends JpaRepository<Indicador, Long> {

    List<Indicador> findByAtivoTrueOrderByOrdemAscIdAsc();
}
