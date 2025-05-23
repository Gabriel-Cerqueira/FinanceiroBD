import Modelo.Usuario;
import Modelo.Categoria;
import Modelo.Transacao;
import ModeloDAO.UsuarioDAO;
import ModeloDAO.CategoriaDAO;
import ModeloDAO.TransacaoDAO;
import java.math.BigDecimal;
import java.time.LocalDate;

public class Principal {
    public static void main(String[] args) {
        Usuario usuario1 = new Usuario();
        usuario1.setNomeJoão Silva;
        usuario1.setEmailjoao@email.com;
        usuario1.setSenhasenha123;

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        usuarioDAO.inserir(usuario1);

        Categoria categoria1 = new Categoria();
        categoria1.setNomeAlimentação;
        categoria1.setUsuarioId(usuario1.getIdUsuario());

        Categoria categoria2 = new Categoria();
        categoria2.setNomeTransporte;
        categoria2.setUsuarioId(usuario1.getIdUsuario());

        CategoriaDAO categoriaDAO = new CategoriaDAO();
        categoriaDAO.inserir(categoria1);
        categoriaDAO.inserir(categoria2);

        Transacao transacao1 = new Transacao();
        transacao1.setData(LocalDate.now());
        transacao1.setCategoriaId(categoria1.getIdCategoria());
        transacao1.setTipoPagamentoCartão de Crédito;
        transacao1.setInformacaoAdicionalSupermercado;
        transacao1.setValor(new BigDecimal350.50);
        transacao1.setTipo(Transacao.TipoTransacao.SAIDA);
        transacao1.setUsuarioId(usuario1.getIdUsuario());

        Transacao transacao2 = new Transacao();
        transacao2.setData(LocalDate.now().minusDays(5));
        transacao2.setCategoriaId(categoria2.getIdCategoria());
        transacao2.setTipoPagamentoDinheiro;
        transacao2.setInformacaoAdicionalCombustível;
        transacao2.setValor(new BigDecimal200.00);
        transacao2.setTipo(Transacao.TipoTransacao.SAIDA);
        transacao2.setUsuarioId(usuario1.getIdUsuario());

        TransacaoDAO transacaoDAO = new TransacaoDAO();
        transacaoDAO.inserir(transacao1);
        transacaoDAO.inserir(transacao2);

        System.out.println=== [ SISTEMA FINANCEIRO ] ===;
        System.out.println();

        System.out.println--- [ Usuário ] ---;
        System.out.printlnID: " + usuario1.getIdUsuario());
        System.out.printlnNome: " + usuario1.getNome());
        System.out.printlnEmail: " + usuario1.getEmail());
        System.out.println();

        System.out.println--- [ Categorias ] ---;
        Categoria categoriaRecuperada1 = categoriaDAO.pesquisarPorCodigo(categoria1.getIdCategoria());
        System.out.printlnID Categoria: " + categoriaRecuperada1.getIdCategoria());
        System.out.printlnNome: " + categoriaRecuperada1.getNome());
        System.out.println();

        Categoria categoriaRecuperada2 = categoriaDAO.pesquisarPorCodigo(categoria2.getIdCategoria());
        System.out.printlnID Categoria: " + categoriaRecuperada2.getIdCategoria());
        System.out.printlnNome: " + categoriaRecuperada2.getNome());
        System.out.println();

        System.out.println--- [ Transações ] ---;
        Transacao transacaoRecuperada1 = transacaoDAO.pesquisarPorCodigo(transacao1.getIdTransacao());
        System.out.printlnID Transação: " + transacaoRecuperada1.getIdTransacao());
        System.out.printlnData: " + transacaoRecuperada1.getData());
        System.out.printlnCategoria: " + categoriaDAO.pesquisarPorCodigo(transacaoRecuperada1.getCategoriaId()).getNome());
        System.out.printlnValor: R$ " + transacaoRecuperada1.getValor());
        System.out.printlnTipo: " + transacaoRecuperada1.getTipo());
        System.out.println();

        Transacao transacaoRecuperada2 = transacaoDAO.pesquisarPorCodigo(transacao2.getIdTransacao());
        System.out.printlnID Transação: " + transacaoRecuperada2.getIdTransacao());
        System.out.printlnData: " + transacaoRecuperada2.getData());
        System.out.printlnCategoria: " + categoriaDAO.pesquisarPorCodigo(transacaoRecuperada2.getCategoriaId()).getNome());
        System.out.printlnValor: R$ " + transacaoRecuperada2.getValor());
        System.out.printlnTipo: " + transacaoRecuperada2.getTipo());
    }
}