<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="File d'attente du jour — espace infirmier.">
    <title>File d&rsquo;attente — TéléExpertise</title>
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
                <span class="page-index">FILE D&rsquo;ATTENTE / JOUR</span>
            </div>

            <div class="infirmier-intro">
                <h1>File <em>d&rsquo;attente.</em></h1>
                <p>Patients enregistrés le <c:out value="${today}" />, par ordre d&rsquo;arrivée.</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert" role="alert">
                    <svg class="icon" aria-hidden="true"><use href="#icon-info"/></svg>
                    <p><strong>Chargement impossible</strong><c:out value="${errorMessage}" /></p>
                </div>
            </c:if>

            <section class="panel" aria-labelledby="titre-file">
                <div class="panel-head">
                    <div>
                        <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg> Patients du jour</p>
                        <h2 id="titre-file">Arrivées enregistrées</h2>
                        <p><c:out value="${fileAttente == null ? 0 : fileAttente.size()}" /> patient(s) en attente.</p>
                    </div>
                    <a class="btn-link" href="${pageContext.request.contextPath}/infirmier/patient">+ Ajouter un patient</a>
                </div>
                <div class="table-wrap">
                    <table class="infirmier-table">
                        <thead>
                            <tr>
                                <th scope="col">Patient</th>
                                <th scope="col">N° sécurité sociale</th>
                                <th scope="col">Heure d&rsquo;arrivée</th>
                                <th scope="col">Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty fileAttente}">
                                    <c:forEach var="entree" items="${fileAttente}">
                                        <tr>
                                            <td class="patient-cell">
                                                <strong><c:out value="${entree.patient.prenom}" /> <c:out value="${entree.patient.nom}" /></strong>
                                            </td>
                                            <td><c:out value="${entree.patient.numeroSecuriteSociale}" /></td>
                                            <td><c:out value="${entree.heureArrivee}" /></td>
                                            <td><span class="status-pill"><c:out value="${entree.statut}" /></span></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="empty-state">Aucun patient dans la file d&rsquo;attente pour le moment.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
        <%@ include file="../fragments/auth-footer.jspf" %>
    </div>
</body>
</html>
