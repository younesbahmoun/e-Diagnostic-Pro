<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="Tableau de bord généraliste — dossiers patients et consultations.">
    <title>Tableau de bord — TéléExpertise</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/infirmier.css">
</head>
<body class="infirmier-page">
    <a class="skip-link" href="#contenu">Aller au contenu</a>
    <%@ include file="../fragments/auth-icons.jspf" %>
    <div class="page-shell">
        <%@ include file="../fragments/generaliste-navbar.jspf" %>
        <main id="contenu">
            <div class="page-heading">
                <p class="eyebrow">Espace généraliste</p>
                <span class="page-index">TABLEAU DE BORD</span>
            </div>

            <div class="infirmier-intro">
                <h1>Consulter. <em>Décider.</em></h1>
                <p>Ouvrez le dossier d&rsquo;un patient en attente, réalisez la consultation, puis clôturez ou demandez un avis spécialiste.</p>
            </div>

            <div class="infirmier-grid">
                <a class="panel action-card" href="${pageContext.request.contextPath}/generaliste/dossier">
                    <span class="action-icon"><svg class="icon" aria-hidden="true"><use href="#icon-person"/></svg></span>
                    <h2>Patients en attente</h2>
                    <p>Ouvrir le dossier d&rsquo;un patient (informations et signes vitaux saisis par l&rsquo;infirmier) et créer la consultation.</p>
                    <span class="card-foot">Voir la file d&rsquo;attente <svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></span>
                </a>
                <div class="panel panel-accent">
                    <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-stethoscope"/></svg> Parcours de consultation</p>
                    <h2>Trois gestes simples</h2>
                    <p>1. Ouvrez le dossier et créez la consultation. 2. Prise en charge directe : diagnostic, traitement, clôture. 3. Sinon : choisissez une spécialité, un spécialiste et un créneau, puis envoyez la demande d&rsquo;avis.</p>
                </div>
            </div>
        </main>
        <%@ include file="../fragments/auth-footer.jspf" %>
    </div>
</body>
</html>
