<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="Tableau de bord infirmier — accueil patient et file d'attente du jour.">
    <title>Tableau de bord — TéléExpertise</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/infirmier.css">
</head>
<body class="infirmier-page">
    <a class="skip-link" href="#contenu">Aller au contenu</a>
    <%@ include file="../fragments/auth-icons.jspf" %>
    <div class="page-shell">
        <%@ include file="../fragments/infirmier-navbar.jspf" %>
        <main id="contenu">
            <div class="page-heading">
                <p class="eyebrow">Espace infirmier</p>
                <span class="page-index">TABLEAU DE BORD</span>
            </div>

            <div class="infirmier-intro">
                <h1>Accueillir. <em>Orienter.</em></h1>
                <p>Recherchez un patient par son numéro de sécurité sociale, enregistrez ses signes vitaux et suivez la file d&rsquo;attente du jour.</p>
            </div>

            <div class="infirmier-grid">
                <a class="panel action-card" href="${pageContext.request.contextPath}/infirmier/patient">
                    <span class="action-icon"><svg class="icon" aria-hidden="true"><use href="#icon-person"/></svg></span>
                    <h2>Accueil patient</h2>
                    <p>Rechercher un dossier existant ou créer un nouveau dossier, puis saisir les signes vitaux.</p>
                    <span class="card-foot">Rechercher un patient <svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></span>
                </a>
                <a class="panel action-card panel-accent" href="${pageContext.request.contextPath}/infirmier/file-attente">
                    <span class="action-icon"><svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg></span>
                    <h2>File d&rsquo;attente</h2>
                    <p>Consulter les patients enregistrés aujourd&rsquo;hui, par ordre d&rsquo;arrivée.</p>
                    <span class="card-foot">Voir la file du jour <svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></span>
                </a>
            </div>

            <section class="panel" aria-label="Rappel du parcours">
                <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-pulse"/></svg> Parcours d&rsquo;accueil</p>
                <h2>Trois gestes simples</h2>
                <p>1. Recherchez le patient. 2. Saisissez les signes vitaux. 3. Le patient rejoint automatiquement la file d&rsquo;attente du jour.</p>
            </section>
        </main>
        <%@ include file="../fragments/auth-footer.jspf" %>
    </div>
</body>
</html>
