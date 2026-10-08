<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="Dossier patient — espace généraliste.">
    <title>Dossier patient — TéléExpertise</title>
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
                <span class="page-index">DOSSIER / PATIENT</span>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert" role="alert">
                    <svg class="icon" aria-hidden="true"><use href="#icon-info"/></svg>
                    <p><c:out value="${errorMessage}" /></p>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty patient}">
                    <div class="infirmier-intro">
                        <h1>Patients <em>en attente.</em></h1>
                        <p>Choisissez un patient pour ouvrir son dossier complet.</p>
                    </div>
                    <section class="panel" aria-labelledby="titre-file">
                        <div class="panel-head">
                            <div>
                                <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-person"/></svg> File d&rsquo;attente</p>
                                <h2 id="titre-file">Dossiers à consulter</h2>
                                <p><c:out value="${fileAttente == null ? 0 : fileAttente.size()}" /> patient(s) en attente.</p>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="infirmier-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Patient</th>
                                        <th scope="col">N° sécurité sociale</th>
                                        <th scope="col">Heure d&rsquo;arrivée</th>
                                        <th scope="col">Dossier</th>
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
                                                    <td><a class="btn-link" href="${pageContext.request.contextPath}/generaliste/dossier?patientId=${entree.patient.id}">Ouvrir le dossier</a></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="empty-state">Aucun patient en attente pour le moment.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:when>

                <c:otherwise>
                    <div class="infirmier-intro">
                        <h1>Dossier de <em><c:out value="${patient.prenom}" /> <c:out value="${patient.nom}" />.</em></h1>
                        <p>Informations saisies par l&rsquo;infirmier : identité, antécédents et signes vitaux.</p>
                    </div>

                    <section class="panel" aria-labelledby="titre-identite" style="margin-bottom: 20px;">
                        <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-person"/></svg> Identité</p>
                        <h2 id="titre-identite"><c:out value="${patient.prenom}" /> <c:out value="${patient.nom}" /></h2>
                        <div class="patient-recap">
                            <div><span>Date de naissance</span><strong><c:out value="${patient.dateNaissance}" /></strong></div>
                            <div><span>N° sécurité sociale</span><strong><c:out value="${patient.numeroSecuriteSociale}" /></strong></div>
                            <div><span>Téléphone</span><strong><c:out value="${patient.telephone}" /></strong></div>
                        </div>
                        <div class="patient-recap">
                            <div><span>Antécédents</span><strong><c:out value="${patient.antecedents}" /></strong></div>
                            <div><span>Allergies</span><strong><c:out value="${patient.allergies}" /></strong></div>
                            <div><span>Traitements en cours</span><strong><c:out value="${patient.traitementsEnCours}" /></strong></div>
                        </div>
                    </section>

                    <section class="panel" aria-labelledby="titre-vitaux" style="margin-bottom: 20px;">
                        <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-pulse"/></svg> Signes vitaux</p>
                        <h2 id="titre-vitaux">Dernières mesures</h2>
                        <div class="table-wrap">
                            <table class="infirmier-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Date</th>
                                        <th scope="col">Tension</th>
                                        <th scope="col">Cœur (bpm)</th>
                                        <th scope="col">Temp. (°C)</th>
                                        <th scope="col">Resp.</th>
                                        <th scope="col">Poids (kg)</th>
                                        <th scope="col">Taille (cm)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty signesVitaux}">
                                            <c:forEach var="sv" items="${signesVitaux}">
                                                <tr>
                                                    <td><c:out value="${sv.dateMesure}" /></td>
                                                    <td><c:out value="${sv.tensionArterielle}" /></td>
                                                    <td><c:out value="${sv.frequenceCardiaque}" /></td>
                                                    <td><c:out value="${sv.temperature}" /></td>
                                                    <td><c:out value="${sv.frequenceRespiratoire}" /></td>
                                                    <td><c:out value="${sv.poids}" /></td>
                                                    <td><c:out value="${sv.taille}" /></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="7" class="empty-state">Aucun signe vital enregistré.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <section class="panel" aria-labelledby="titre-consult" style="margin-bottom: 20px;">
                        <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-stethoscope"/></svg> Consultation</p>
                        <h2 id="titre-consult">Nouvelle consultation</h2>
                        <p>Décrivez le motif, l&rsquo;examen clinique et les symptômes rapportés par le patient.</p>
                        <form class="auth-form" method="post" action="${pageContext.request.contextPath}/generaliste/dossier" accept-charset="UTF-8">
                            <input type="hidden" name="patientId" value="${patient.id}">
                            <div class="form-grid">
                                <div class="field field-full">
                                    <label class="field-label" for="motif">Motif de consultation</label>
                                    <input class="field-input" type="text" id="motif" name="motif" maxlength="255" required>
                                </div>
                                <div class="field field-full">
                                    <label class="field-label" for="observations">Examen clinique, symptômes et observations</label>
                                    <textarea class="field-input" id="observations" name="observations"></textarea>
                                </div>
                                <div class="form-actions">
                                    <button class="submit-button" type="submit"><span>Créer la consultation</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                                </div>
                            </div>
                        </form>
                    </section>

                    <section class="panel" aria-labelledby="titre-historique">
                        <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg> Historique</p>
                        <h2 id="titre-historique">Consultations précédentes</h2>
                        <div class="table-wrap">
                            <table class="infirmier-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Date</th>
                                        <th scope="col">Motif</th>
                                        <th scope="col">Statut</th>
                                        <th scope="col">Détail</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty consultations}">
                                            <c:forEach var="c" items="${consultations}">
                                                <tr>
                                                    <td><c:out value="${c.dateConsultation}" /></td>
                                                    <td><c:out value="${c.motif}" /></td>
                                                    <td><span class="status-pill"><c:out value="${c.statut}" /></span></td>
                                                    <td><a class="btn-link" href="${pageContext.request.contextPath}/generaliste/consultation?id=${c.id}">Ouvrir</a></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="4" class="empty-state">Aucune consultation précédente.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:otherwise>
            </c:choose>
        </main>
        <%@ include file="../fragments/auth-footer.jspf" %>
    </div>
</body>
</html>
